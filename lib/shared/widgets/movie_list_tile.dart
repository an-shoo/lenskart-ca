import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/spacing_constants.dart';
import '../../core/models/movie.dart';
import '../../core/models/genre.dart';

class MovieListTile extends StatelessWidget {
  final Movie movie;
  final bool isFavourite;
  final bool isInWatchlist;
  final VoidCallback onTap;
  final VoidCallback onFavouriteTap;
  final VoidCallback onWatchlistTap;

  const MovieListTile({
    super.key,
    required this.movie,
    required this.isFavourite,
    required this.isInWatchlist,
    required this.onTap,
    required this.onFavouriteTap,
    required this.onWatchlistTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.md),
                bottomLeft: Radius.circular(AppRadius.md),
              ),
              child: SizedBox(
                width: 100,
                height: 140,
                child: _buildPoster(),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md + 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs + 2),
                    
                    Row(
                      children: [
                        if (movie.releaseYear.isNotEmpty) ...[
                          Text(
                            movie.releaseYear,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _getRatingColor(movie.voteAverage),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.white,
                                size: AppIconSize.xs,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    
                    if (movie.genreIds.isNotEmpty)
                      Text(
                        GenreMap.getGenreNames(movie.genreIds.take(2).toList()).join(' • '),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: AppSpacing.md),
                    
                    Row(
                      children: [
                        _ActionChip(
                          icon: isFavourite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          label: isFavourite ? 'Favourited' : 'Favourite',
                          isActive: isFavourite,
                          activeColor: AppColors.error,
                          onTap: onFavouriteTap,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _ActionChip(
                          icon: isInWatchlist
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          label: isInWatchlist ? 'In Watchlist' : 'Watchlist',
                          isActive: isInWatchlist,
                          activeColor: AppColors.accent,
                          onTap: onWatchlistTap,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster() {
    if (movie.posterUrl.isEmpty) {
      return Container(
        color: AppColors.surfaceLight,
        child: const Center(
          child: Icon(
            Icons.movie_outlined,
            size: 40,
            color: AppColors.textMuted,
          ),
        ),
      );
    }

    return Image.network(
      movie.posterUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: AppColors.surfaceLight,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: AppColors.surfaceLight,
        child: const Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 40,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 7.0) return AppColors.ratingHigh;
    if (rating >= 5.0) return AppColors.ratingMedium;
    return AppColors.ratingLow;
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2, vertical: AppSpacing.xs + 2),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withOpacity(0.15)
              : AppColors.surfaceLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(
            color: isActive
                ? activeColor.withOpacity(0.4)
                : AppColors.surfaceLight.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppIconSize.xs + 2,
              color: isActive ? activeColor : AppColors.textMuted,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: isActive ? activeColor : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

