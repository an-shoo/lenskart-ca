import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/spacing_constants.dart';
import '../../../core/models/movie.dart';
import '../providers/favourites_provider.dart';
import '../../watchlist/providers/watchlist_provider.dart';
import '../../movie_detail/screens/movie_detail_screen.dart';
import '../../../shared/widgets/movie_list_tile.dart';
import '../../../shared/widgets/empty_widget.dart';
import '../../../shared/widgets/loading_widget.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

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
                                color: AppColors.error.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: const Icon(
                                Icons.favorite_rounded,
                                color: AppColors.error,
                                size: AppIconSize.lg,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              'Favourites',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Consumer<FavouritesProvider>(
                          builder: (context, provider, _) {
                            return Text(
                              '${provider.favourites.length} movies',
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
                child: Consumer<FavouritesProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const LoadingWidget(message: 'Loading favourites...');
                    }

                    if (provider.isEmpty) {
                      return const EmptyWidget(
                        icon: Icons.favorite_outline_rounded,
                        title: 'No Favourites Yet',
                        subtitle: 'Start adding movies to your favourites list',
                      );
                    }

                    return _buildFavouritesList(context, provider.favourites);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavouritesList(BuildContext context, List<Movie> movies) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 100),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Consumer2<FavouritesProvider, WatchlistProvider>(
          builder: (context, favProvider, watchProvider, _) {
            return Dismissible(
              key: Key('favourite_${movie.id}'),
              direction: DismissDirection.endToStart,
              onDismissed: (_) {
                favProvider.removeFromFavourites(movie.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${movie.title} removed from favourites'),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: AppColors.primary,
                      onPressed: () {
                        favProvider.addToFavourites(movie);
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
                isFavourite: true,
                isInWatchlist: watchProvider.isInWatchlist(movie.id),
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

