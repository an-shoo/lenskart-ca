import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/spacing_constants.dart';
import '../../../core/models/movie.dart';
import '../providers/watchlist_provider.dart';
import '../../favourites/providers/favourites_provider.dart';
import '../../movie_detail/screens/movie_detail_screen.dart';
import '../../../shared/widgets/movie_list_tile.dart';
import '../../../shared/widgets/empty_widget.dart';
import '../../../shared/widgets/loading_widget.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  void _navigateToDetail(BuildContext context, Movie movie) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => MovieDetailScreen(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.lg, AppSpacing.screenPadding, AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: const Icon(
                                Icons.bookmark_rounded,
                                color: AppColors.accent,
                                size: AppIconSize.lg,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              'Watchlist',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Consumer<WatchlistProvider>(
                          builder: (context, provider, _) {
                            return Text(
                              '${provider.watchlist.length} movies to watch',
                              style: Theme.of(context).textTheme.bodyMedium,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              Expanded(
                child: Consumer<WatchlistProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const LoadingWidget(message: 'Loading watchlist...');
                    }

                    if (provider.isEmpty) {
                      return const EmptyWidget(
                        icon: Icons.bookmark_outline_rounded,
                        title: 'No Movies in Watchlist',
                        subtitle: 'Add movies you want to watch later',
                      );
                    }

                    return _buildWatchlist(context, provider.watchlist);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWatchlist(BuildContext context, List<Movie> movies) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 100),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Consumer2<FavouritesProvider, WatchlistProvider>(
          builder: (context, favProvider, watchProvider, _) {
            return Dismissible(
              key: Key('watchlist_${movie.id}'),
              direction: DismissDirection.endToStart,
              onDismissed: (_) {
                watchProvider.removeFromWatchlist(movie.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${movie.title} removed from watchlist'),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: AppColors.primary,
                      onPressed: () {
                        watchProvider.addToWatchlist(movie);
                      },
                    ),
                  ),
                );
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: AppSpacing.xl),
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                  size: AppIconSize.xl,
                ),
              ),
              child: MovieListTile(
                movie: movie,
                isFavourite: favProvider.isFavourite(movie.id),
                isInWatchlist: true,
                onTap: () => _navigateToDetail(context, movie),
                onFavouriteTap: () => favProvider.toggleFavourite(movie),
                onWatchlistTap: () => watchProvider.toggleWatchlist(movie),
              ),
            );
          },
        );
      },
    );
  }
}

