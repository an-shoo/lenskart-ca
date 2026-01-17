import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
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
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
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
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 100,
                height: 140,
                child: _buildPoster(),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 6),
                    
                    Row(
                      children: [
                        if (movie.releaseYear.isNotEmpty) ...[
                          Text(
                            movie.releaseYear,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
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
                                size: 12,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    if (movie.genreIds.isNotEmpty)
                      Text(
                        GenreMap.getGenreNames(movie.genreIds.take(2).toList()).join(' • '),
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 12),
                    
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
                        const SizedBox(width: 8),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withOpacity(0.15)
              : AppColors.surfaceLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
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
              size: 14,
              color: isActive ? activeColor : AppColors.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive ? activeColor : AppColors.textMuted,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

