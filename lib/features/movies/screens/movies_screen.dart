import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/movie.dart';
import '../providers/movie_provider.dart';
import '../../favourites/providers/favourites_provider.dart';
import '../../watchlist/providers/watchlist_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/search_bar_widget.dart';
import '../../movie_detail/screens/movie_detail_screen.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/empty_widget.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<MovieProvider>();
      if (!provider.isSearching) {
        provider.loadMoreMovies();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToDetail(Movie movie) {
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
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Discover',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Find your next favorite movie',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.movie_filter_rounded,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search bar
                    SearchBarWidget(
                      controller: _searchController,
                      onChanged: (query) {
                        context.read<MovieProvider>().searchMovies(query);
                      },
                      onClear: () {
                        _searchController.clear();
                        context.read<MovieProvider>().clearSearch();
                      },
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: Consumer<MovieProvider>(
                  builder: (context, provider, child) {
                    // Show search results or popular movies
                    if (provider.isSearching) {
                      return _buildSearchResults(provider);
                    }
                    return _buildMoviesList(provider);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviesList(MovieProvider provider) {
    switch (provider.moviesState) {
      case LoadingState.loading:
        if (provider.popularMovies.isEmpty) {
          return const LoadingWidget(message: 'Loading movies...');
        }
        return _buildMoviesGrid(provider.popularMovies, isLoading: true);
      
      case LoadingState.error:
        if (provider.popularMovies.isEmpty) {
          return CustomErrorWidget(
            message: provider.errorMessage,
            onRetry: () => provider.loadPopularMovies(refresh: true),
          );
        }
        return _buildMoviesGrid(provider.popularMovies);
      
      case LoadingState.empty:
        return const EmptyWidget(
          icon: Icons.movie_outlined,
          title: 'No Movies Found',
          subtitle: 'Check back later for new content',
        );
      
      case LoadingState.loaded:
      case LoadingState.initial:
        return _buildMoviesGrid(provider.popularMovies);
    }
  }

  Widget _buildSearchResults(MovieProvider provider) {
    switch (provider.searchState) {
      case LoadingState.loading:
        return const LoadingWidget(message: 'Searching...');
      
      case LoadingState.error:
        return CustomErrorWidget(
          message: provider.searchErrorMessage,
          onRetry: () => provider.searchMovies(provider.searchQuery),
        );
      
      case LoadingState.empty:
        return EmptyWidget(
          icon: Icons.search_off_rounded,
          title: 'No Results',
          subtitle: 'No movies found for "${provider.searchQuery}"',
        );
      
      case LoadingState.loaded:
        return _buildMoviesGrid(provider.searchResults);
      
      case LoadingState.initial:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMoviesGrid(List<Movie> movies, {bool isLoading = false}) {
    return RefreshIndicator(
      onRefresh: () => context.read<MovieProvider>().loadPopularMovies(refresh: true),
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.58,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: movies.length + (isLoading ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= movies.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
            );
          }
          
          final movie = movies[index];
          return Consumer2<FavouritesProvider, WatchlistProvider>(
            builder: (context, favProvider, watchProvider, child) {
              return MovieCard(
                movie: movie,
                isFavourite: favProvider.isFavourite(movie.id),
                isInWatchlist: watchProvider.isInWatchlist(movie.id),
                onTap: () => _navigateToDetail(movie),
                onFavouriteTap: () => favProvider.toggleFavourite(movie),
                onWatchlistTap: () => watchProvider.toggleWatchlist(movie),
              );
            },
          );
        },
      ),
    );
  }
}

