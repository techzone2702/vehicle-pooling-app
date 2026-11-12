import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../models/booking_model.dart';
import '../services/booking_service.dart';

/// Screen displaying passenger bookings and joining requests.
/// Features dual tabs: "Sent Requests" for active/pending reservations and
/// "Booking History" for past, completed, rejected, or cancelled requests.
class BookingScreen extends StatefulWidget {
  final bool isTab;

  const BookingScreen({super.key, this.isTab = false});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String _currentUserId = 'u_1';
  bool _isLoading = false;
  List<BookingModel> _userBookings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
    });

    final bookings = await PlaceholderBookingService.instance
        .getBookingsForUser(_currentUserId);

    if (mounted) {
      setState(() {
        _userBookings = bookings;
        _isLoading = false;
      });
    }
  }

  List<BookingModel> get _activeRequests {
    return _userBookings.where((b) {
      return b.status == BookingStatus.pending ||
          b.status == BookingStatus.accepted;
    }).toList();
  }

  List<BookingModel> get _historyRequests {
    return _userBookings.where((b) {
      return b.status == BookingStatus.rejected ||
          b.status == BookingStatus.cancelled;
    }).toList();
  }

  Future<void> _cancelBooking(BookingModel booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Join Request'),
        content: const Text(
          'Are you sure you want to cancel this join request? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep Request'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel Request'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await PlaceholderBookingService.instance.updateBookingStatus(
        bookingId: booking.id,
        status: BookingStatus.cancelled,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Join request cancelled successfully.'),
            backgroundColor: AppColors.textSecondary,
          ),
        );
        _loadBookings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        automaticallyImplyLeading: !widget.isTab,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sent Requests'),
                  if (_activeRequests.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_activeRequests.length}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Booking History'),
                  if (_historyRequests.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textMuted.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_historyRequests.length}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [_buildActiveRequestsTab(), _buildHistoryRequestsTab()],
            ),
    );
  }

  Widget _buildActiveRequestsTab() {
    if (_activeRequests.isEmpty) {
      return EmptyStateView(
        icon: Icons.bookmark_border_rounded,
        title: 'No Sent Requests',
        description: 'You haven\'t requested to join any rides yet. Search for available rides and send requests to carpoolers.',
        actionText: 'Find a Ride',
        onActionPressed: () => Navigator.pushNamed(context, AppRoutes.findRide),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: _activeRequests.length,
        itemBuilder: (context, index) {
          final booking = _activeRequests[index];
          return _buildBookingCard(booking, isHistory: false);
        },
      ),
    );
  }

  Widget _buildHistoryRequestsTab() {
    if (_historyRequests.isEmpty) {
      return const EmptyStateView(
        icon: Icons.history_rounded,
        title: 'No Booking History',
        description: 'Past completed trips, rejected join requests, or cancelled bookings will be safely archived here.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: _historyRequests.length,
        itemBuilder: (context, index) {
          final booking = _historyRequests[index];
          return _buildBookingCard(booking, isHistory: true);
        },
      ),
    );
  }

  Widget _buildBookingCard(BookingModel booking, {required bool isHistory}) {
    final statusBadge = _buildStatusBadge(booking.status);

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Booking ID and Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      booking.status == BookingStatus.accepted
                          ? Icons.verified_rounded
                          : Icons.bookmark_rounded,
                      size: 18,
                      color: booking.status == BookingStatus.accepted
                          ? AppColors.primary
                          : AppColors.secondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Booking #${booking.id.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                statusBadge,
              ],
            ),

            const Divider(height: 20),

            // Route Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.trip_origin_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    Container(width: 2, height: 22, color: AppColors.border),
                    const Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: AppColors.error,
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.source ?? 'Pickup Point',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        booking.destination ?? 'Drop-off Destination',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Trip Timing & Fare Breakdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        booking.departureTime != null
                            ? Formatters.formatTime(booking.departureTime!)
                            : 'Scheduled',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '•',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${booking.seatsBooked} seat${booking.seatsBooked > 1 ? "s" : ""}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    Formatters.formatCurrency(booking.totalPrice),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Passenger/Action details if Pending
            if (booking.status == BookingStatus.pending) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Requested ${Formatters.formatRelativeTime(booking.requestedAt)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  InkWell(
                    onTap: () => _cancelBooking(booking),
                    borderRadius: BorderRadius.circular(6),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: AppColors.error,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Cancel Request',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (booking.status == BookingStatus.accepted) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Ride confirmed! Be at the pickup spot 5 mins before departure.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BookingStatus status) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (status) {
      case BookingStatus.pending:
        bg = AppColors.warning.withValues(alpha: 0.15);
        fg = const Color(0xFFB78103);
        label = 'Pending';
        icon = Icons.hourglass_top_rounded;
        break;
      case BookingStatus.accepted:
        bg = AppColors.primaryLight;
        fg = AppColors.primaryDark;
        label = 'Accepted';
        icon = Icons.check_circle_rounded;
        break;
      case BookingStatus.rejected:
        bg = AppColors.error.withValues(alpha: 0.12);
        fg = AppColors.error;
        label = 'Rejected';
        icon = Icons.cancel_rounded;
        break;
      case BookingStatus.cancelled:
        bg = AppColors.textMuted.withValues(alpha: 0.15);
        fg = AppColors.textSecondary;
        label = 'Cancelled';
        icon = Icons.block_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
