import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/spacing_constants.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/genre.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isFavourite;
  final bool isInWatchlist;
  final VoidCallback onTap;
  final VoidCallback onFavouriteTap;
  final VoidCallback onWatchlistTap;

  const MovieCard({
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildPoster(),
              
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.95),
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
              
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs + 2),
                    
                    if (movie.genreIds.isNotEmpty)
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: movie.genreIds.take(2).map((id) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.4),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              GenreMap.getGenreName(id),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.primaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: _getRatingColor(movie.voteAverage),
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.white,
                                size: AppIconSize.xs,
                              ),
                              const SizedBox(width: AppSpacing.xs),
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
                        const Spacer(),
                        _ActionButton(
                          icon: isFavourite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavourite ? AppColors.error : Colors.white70,
                          onTap: onFavouriteTap,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _ActionButton(
                          icon: isInWatchlist
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: isInWatchlist ? AppColors.accent : Colors.white70,
                          onTap: onWatchlistTap,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              if (movie.releaseYear.isNotEmpty)
                Positioned(
                  top: AppSpacing.md,
                  left: AppSpacing.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm + 2,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      movie.releaseYear,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoster() {
    if (movie.posterUrl.isEmpty) {
      return Container(
        color: AppColors.surface,
        child: const Center(
          child: Icon(
            Icons.movie_outlined,
            size: AppIconSize.huge,
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
          color: AppColors.surface,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: AppColors.surface,
        child: const Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: AppIconSize.huge,
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Icon(
          icon,
          color: color,
          size: AppIconSize.sm + 2,
        ),
      ),
    );
  }
}

