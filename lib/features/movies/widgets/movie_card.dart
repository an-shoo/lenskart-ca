import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
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
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Movie poster
              _buildPoster(),
              
              // Gradient overlay
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
              
              // Content
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 6),
                    
                    // Genre chips
                    if (movie.genreIds.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: movie.genreIds.take(2).map((id) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.4),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              GenreMap.getGenreName(id),
                              style: const TextStyle(
                                color: AppColors.primaryLight,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 8),
                    
                    // Rating and actions row
                    Row(
                      children: [
                        // Rating
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getRatingColor(movie.voteAverage),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
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
                        const Spacer(),
                        // Action buttons
                        _ActionButton(
                          icon: isFavourite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavourite ? AppColors.error : Colors.white70,
                          onTap: onFavouriteTap,
                        ),
                        const SizedBox(width: 8),
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
              
              // Year badge
              if (movie.releaseYear.isNotEmpty)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      movie.releaseYear,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
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
            size: 60,
            color: AppColors.textMuted,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: movie.posterUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColors.surface,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.surface,
        child: const Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 60,
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
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
          size: 18,
        ),
      ),
    );
  }
}

