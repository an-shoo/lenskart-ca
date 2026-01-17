import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/spacing_constants.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/models/movie.dart';
import '../../../core/services/notification_service.dart';
import '../../movies/providers/movie_provider.dart';
import '../../favourites/providers/favourites_provider.dart';
import '../../watchlist/providers/watchlist_provider.dart';
import '../widgets/circular_rating_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMovieDetails();
    });
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  void _loadMovieDetails() {
    context.read<MovieProvider>().loadMovieDetails(widget.movie.id);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePlayNow() async {
    await NotificationService.showMoviePlayingNotification(widget.movie.title);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.play_circle_filled, color: AppColors.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Movie is Playing: ${widget.movie.title}',
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.surface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieProvider>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.backgroundGradient,
                ),
              ),
              CustomScrollView(
                slivers: [
                  _buildSliverAppBar(),
                  SliverToBoxAdapter(
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: _buildContent(provider),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isWeb = screenWidth > 600;
    final expandedHeight =
        isWeb ? (screenHeight * 0.4).clamp(350.0, 500.0) : 300.0;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: Container(
        margin: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Consumer2<FavouritesProvider, WatchlistProvider>(
          builder: (context, favProvider, watchProvider, _) {
            final isFavourite = favProvider.isFavourite(widget.movie.id);
            final isInWatchlist = watchProvider.isInWatchlist(widget.movie.id);
            
            return Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFavourite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavourite
                          ? AppColors.error
                          : Colors.white,
                    ),
                    onPressed: () {
                      favProvider.toggleFavourite(widget.movie);
                      SnackbarHelper.showAddSnackBar(
                        context,
                        isFavourite ? 'Removed from favourites' : 'Added to favourites',
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isInWatchlist
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isInWatchlist
                          ? AppColors.accent
                          : Colors.white,
                    ),
                    onPressed: () {
                      watchProvider.toggleWatchlist(widget.movie);
                      SnackbarHelper.showAddSnackBar(
                        context,
                        isInWatchlist ? 'Removed from watchlist' : 'Added to watchlist',
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (widget.movie.backdropUrl.isNotEmpty)
              Image.network(
                widget.movie.backdropUrl,
                fit: isWeb ? BoxFit.fitWidth : BoxFit.cover,
                alignment: Alignment.topCenter,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.surface,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.surface,
                  child: const Icon(
                    Icons.broken_image,
                    color: AppColors.textMuted,
                    size: 60,
                  ),
                ),
              )
            else
              Container(color: AppColors.surface),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    AppColors.background.withOpacity(0.8),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(MovieProvider provider) {
    final detail = provider.selectedMovieDetail;

    if (provider.detailState == LoadingState.loading) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.huge + 8),
        child: LoadingWidget(message: 'Loading details...'),
      );
    }
    
    if (provider.detailState == LoadingState.error) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.huge + 8),
        child: CustomErrorWidget(
          message: provider.detailErrorMessage,
          onRetry: _loadMovieDetails,
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final ratingSize = screenWidth > 600 ? 100.0 : screenWidth * 0.18;
    final clampedRatingSize = ratingSize.clamp(70.0, 120.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.xxl, AppSpacing.screenPadding, AppSpacing.huge + 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (widget.movie.releaseYear.isNotEmpty)
                      Text(
                        widget.movie.releaseYear,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              CircularRatingWidget(
                rating: widget.movie.ratingPercentage,
                size: clampedRatingSize,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (detail != null && detail.genres.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Genre'),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm + 2,
                  runSpacing: AppSpacing.sm + 2,
                  children: detail.genres.map((genre) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm + 2,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.2),
                            AppColors.primaryDark.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        genre.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          _buildSectionTitle('Release Date'),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm + 2),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.primary,
                  size: AppIconSize.md,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                detail?.formattedReleaseDate ??
                    widget.movie.formattedReleaseDate,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (detail != null && detail.runtime != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Runtime'),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm + 2),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: const Icon(
                        Icons.access_time_rounded,
                        color: AppColors.accent,
                        size: AppIconSize.md,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      detail.formattedRuntime,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          _buildSectionTitle('Overview'),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: AppColors.surfaceLight.withOpacity(0.2),
              ),
            ),
            child: Text(
              detail?.overview ??
                  widget.movie.overview ??
                  'No overview available.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.huge),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _handlePlayNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: AppColors.primary.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_circle_filled, size: AppIconSize.xl),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Play Now',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
    );
  }
}
