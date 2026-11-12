import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../services/ride_service.dart';
import '../widgets/ride_result_card.dart';

/// Arguments passed into [FindRideScreen] from Quick Search or external triggers.
class FindRideArgs {
  final String? source;
  final String? destination;
  final DateTime? date;

  const FindRideArgs({this.source, this.destination, this.date});
}

/// Screen allowing passengers to search for rides by departure location,
/// destination, and travel date, with location swapping, detailed result cards,
/// responsive layout, and distinct empty/error states.
class FindRideScreen extends StatefulWidget {
  const FindRideScreen({super.key});

  /// In-memory cache to retain search queries and results across screen transitions.
  static FindRideArgs? lastSearchArgs;
  static RideSearchResult? lastSearchResult;

  @override
  State<FindRideScreen> createState() => _FindRideScreenState();
}

class _FindRideScreenState extends State<FindRideScreen> {
  final _formKey = GlobalKey<FormState>();

  final _sourceController = TextEditingController();
  final _destinationController = TextEditingController();

  late DateTime _selectedDate;
  bool _isSearching = false;
  bool _hasSearched = false;
  RideSearchResult? _searchResult;
  bool _initializedWithArgs = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedWithArgs) {
      _initializedWithArgs = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is FindRideArgs) {
        if (args.source != null && args.source!.trim().isNotEmpty) {
          _sourceController.text = args.source!.trim();
        }
        if (args.destination != null && args.destination!.trim().isNotEmpty) {
          _destinationController.text = args.destination!.trim();
        }
        if (args.date != null) {
          _selectedDate = DateTime(
            args.date!.year,
            args.date!.month,
            args.date!.day,
          );
        }

        // Auto-run search if both locations are present
        if (_sourceController.text.trim().isNotEmpty &&
            _destinationController.text.trim().isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _performSearch();
            }
          });
        }
      } else if (FindRideScreen.lastSearchArgs != null &&
          FindRideScreen.lastSearchResult != null) {
        // Restore cached search
        final cached = FindRideScreen.lastSearchArgs!;
        _sourceController.text = cached.source ?? '';
        _destinationController.text = cached.destination ?? '';
        if (cached.date != null) {
          _selectedDate = cached.date!;
        }
        _searchResult = FindRideScreen.lastSearchResult;
        _hasSearched = true;
      }
    }
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _swapLocations() {
    final temp = _sourceController.text;
    setState(() {
      _sourceController.text = _destinationController.text;
      _destinationController.text = temp;
    });

    // Re-run search if already searched and both fields are non-empty
    if (_hasSearched &&
        _sourceController.text.trim().isNotEmpty &&
        _destinationController.text.trim().isNotEmpty &&
        _sourceController.text.trim().toLowerCase() !=
            _destinationController.text.trim().toLowerCase()) {
      _performSearch();
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(today) ? today : _selectedDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
      if (_hasSearched) {
        _performSearch();
      }
    }
  }

  Future<void> _performSearch() async {
    final formState = _formKey.currentState;
    if (formState != null) {
      final isValid = formState.validate();
      if (!isValid) return;
    } else {
      final src = _sourceController.text.trim();
      final dest = _destinationController.text.trim();
      if (src.isEmpty ||
          dest.isEmpty ||
          src.toLowerCase() == dest.toLowerCase()) {
        return;
      }
    }

    setState(() {
      _isSearching = true;
    });

    final source = _sourceController.text.trim();
    final destination = _destinationController.text.trim();

    try {
      final result = await PlaceholderRideService.instance.searchRidesDetailed(
        source: source,
        destination: destination,
        date: _selectedDate,
      );

      if (!mounted) return;

      setState(() {
        _isSearching = false;
        _hasSearched = true;
        _searchResult = result;
      });

      // Cache search query and result for session retention
      FindRideScreen.lastSearchArgs = FindRideArgs(
        source: source,
        destination: destination,
        date: _selectedDate,
      );
      FindRideScreen.lastSearchResult = result;
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSearching = false;
        _hasSearched = true;
        _searchResult = const RideSearchResult(
          rides: [],
          emptyReason: RideSearchEmptyReason.noMatchingRoute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        title: const Text('Find a Ride'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: AppConstants.smallPadding,
              ),
              children: [
                // Top Search Panel
                _buildSearchCard(),

                const SizedBox(height: AppConstants.defaultPadding),

                // Search Results / Loading / Empty States
                _buildContentArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.saved_search_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Search Available Rides',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            // Route inputs with swap button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _sourceController,
                        label: 'Leaving From',
                        hintText: 'e.g. Koramangala, Bengaluru',
                        prefixIcon: Icons.my_location_rounded,
                        validator: (value) {
                          final trimmed = value?.trim() ?? '';
                          if (trimmed.isEmpty) {
                            return 'Please enter departure location';
                          }
                          if (trimmed.length < 2) {
                            return 'Location must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _destinationController,
                        label: 'Going To',
                        hintText: 'e.g. Whitefield Tech Park',
                        prefixIcon: Icons.location_on_rounded,
                        validator: (value) {
                          final trimmed = value?.trim() ?? '';
                          if (trimmed.isEmpty) {
                            return 'Please enter destination';
                          }
                          if (trimmed.length < 2) {
                            return 'Destination must be at least 2 characters';
                          }
                          if (trimmed.toLowerCase() ==
                              _sourceController.text.trim().toLowerCase()) {
                            return 'Source and destination cannot be identical';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Swap locations button
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _swapLocations,
                    icon: const Icon(Icons.swap_vert_rounded),
                    color: AppColors.primary,
                    tooltip: 'Swap locations',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Travel Date Selector
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Travel Date',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Formatters.formatDate(_selectedDate),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Search button
            CustomButton(
              text: 'Search Rides',
              icon: Icons.search_rounded,
              isLoading: _isSearching,
              onPressed: _isSearching ? null : _performSearch,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentArea() {
    if (_isSearching) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppConstants.largePadding * 2),
        child: LoadingIndicator(message: 'Searching matching carpools...'),
      );
    }

    if (!_hasSearched) {
      return _buildInitialDiscoveryView();
    }

    final rides = _searchResult?.rides ?? [];
    if (rides.isEmpty) {
      return _buildEmptyStateView();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: [
            Text(
              '${rides.length} ${rides.length == 1 ? 'Ride' : 'Rides'} Available',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Sorted by earliest departure',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...rides.map((ride) => RideResultCard(ride: ride)),
      ],
    );
  }

  Widget _buildInitialDiscoveryView() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.explore_rounded,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            'Find Your Next Commute',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your pickup and destination locations above to discover verified, friendly carpools heading your way.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.25),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.eco_rounded, color: AppColors.secondary, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Carpooling saves up to 50% on travel costs while cutting city traffic congestion and emissions.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateView() {
    final reason =
        _searchResult?.emptyReason ?? RideSearchEmptyReason.noMatchingRoute;

    switch (reason) {
      case RideSearchEmptyReason.noMatchingRoute:
        return EmptyStateView(
          icon: Icons.location_off_rounded,
          title: 'No Matching Rides Found',
          description:
              'No carpools currently match "${_sourceController.text.trim()}" to "${_destinationController.text.trim()}". Try searching for major landmarks, metro hubs, or alternate areas.',
          actionText: 'Modify Search',
          onActionPressed: () {
            // Scroll to top or clear fields
          },
        );

      case RideSearchEmptyReason.noRidesOnSelectedDate:
        return EmptyStateView(
          icon: Icons.event_busy_rounded,
          title: 'No Rides on This Date',
          description:
              'No carpools are scheduled on ${Formatters.formatDate(_selectedDate)} for this route. Carpools may be available on adjacent dates.',
          actionText: 'Search Tomorrow',
          onActionPressed: () {
            setState(() {
              _selectedDate = DateTime.now().add(const Duration(days: 1));
            });
            _performSearch();
          },
        );

      case RideSearchEmptyReason.allRidesFullyBooked:
        return EmptyStateView(
          icon: Icons.event_seat_rounded,
          title: 'All Rides Fully Booked',
          description:
              'All scheduled rides between these locations on ${Formatters.formatDate(_selectedDate)} are at full capacity. Please check back later or choose another date.',
          actionText: 'Try Another Date',
          onActionPressed: _pickDate,
        );

      case RideSearchEmptyReason.allRidesDeparted:
        return EmptyStateView(
          icon: Icons.history_toggle_off_rounded,
          title: 'Rides Already Departed',
          description: 'All carpools scheduled for today have already left. Please select a future date or search tomorrow.',
          actionText: 'Search Tomorrow',
          onActionPressed: () {
            setState(() {
              _selectedDate = DateTime.now().add(const Duration(days: 1));
            });
            _performSearch();
          },
        );

      case RideSearchEmptyReason.none:
        return const EmptyStateView(
          icon: Icons.search_off_rounded,
          title: 'No Rides Found',
          description: 'Try adjusting your search criteria or travel date.',
        );
    }
  }
}
