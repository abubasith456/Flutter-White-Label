import 'package:demo_app/components/base/custom_appbar.dart';
import 'package:demo_app/screens/search/components/bloc/search_bloc.dart';
import 'package:demo_app/screens/search/components/search_screen_shimmer.dart';
import 'package:demo_app/app_config.dart';
import 'package:demo_app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_app/utils/navigation_helper.dart';
import 'package:demo_app/models/enums/product_size_type.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<String> _selectedCategories = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    context.read<SearchBloc>().add(LoadData());
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final bloc = context.read<SearchBloc>();
    bloc.add(
      SearchProducts(
        _searchController.text,
        selectedCategories: _selectedCategories,
      ),
    );
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });

    context.read<SearchBloc>().add(
      SearchProducts(
        _searchController.text,
        selectedCategories: _selectedCategories,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: CustomAppBar(
        title: "Search Product",
        subtitle: "search your item",
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppConfig.backgroundColor, Colors.white],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildWelcomeHeader(),
                  const SizedBox(height: 24),
                  _buildSearchField(),
                  const SizedBox(height: 20),
                  _buildCategorySection(),
                  const SizedBox(height: 20),
                  _buildResultsHeader(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildProductList()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What are you",
          style: AppTextStyles.welcomeHeader.copyWith(
            color: AppConfig.primaryTextColor,
          ),
        ),
        Text(
          "looking for?",
          style: AppTextStyles.welcomeHeaderBold.copyWith(
            color: AppConfig.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (query) => _onSearch(),
        style: AppTextStyles.searchInput,
        decoration: InputDecoration(
          hintText: 'Search amazing products...',
          hintStyle: AppTextStyles.searchHint,
          filled: true,
          fillColor: AppConfig.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: AppConfig.greyColor.shade300,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppConfig.primaryColor, width: 2),
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppConfig.gradientColors),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear_rounded, color: AppConfig.greyColor),
                    onPressed: () {
                      _searchController.clear();
                      _onSearch();
                    },
                  )
                  : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchDataLoaded && state.categories.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Categories", style: AppTextStyles.resultsHeader),
              const SizedBox(height: 12),
              _buildCategoryChips(),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCategoryChips() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchDataLoaded) {
          return SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                final isSelected = _selectedCategories.contains(category.id);

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: FilterChip(
                      label: Text(
                        category.name,
                        style: AppTextStyles.categoryChip.copyWith(
                          color:
                              isSelected
                                  ? Colors.white
                                  : AppConfig.primaryTextColor,
                        ),
                      ),
                      selected: isSelected,
                      onSelected:
                          (selected) => _onCategorySelected(category.id),
                      selectedColor: AppConfig.primaryColor,
                      backgroundColor: AppConfig.cardColor,
                      checkmarkColor: Colors.white,
                      elevation: isSelected ? 8 : 2,
                      shadowColor: AppConfig.primaryColor.withOpacity(0.3),
                      side: BorderSide(
                        color:
                            isSelected
                                ? AppConfig.primaryColor
                                : AppConfig.greyColor.shade300,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildResultsHeader() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchDataLoaded) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Results (${state.displayedProducts.length})",
                style: AppTextStyles.resultsHeader,
              ),
              if (state.displayedProducts.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppConfig.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Found",
                    style: AppTextStyles.badgeText.copyWith(
                      color: AppConfig.primaryColor,
                    ),
                  ),
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProductList() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchDataLoading) {
          return const SearchScreenShimmer();
        }

        if (state is SearchDataLoaded) {
          if (state.displayedProducts.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            itemCount: state.displayedProducts.length,
            itemBuilder: (context, index) {
              final product = state.displayedProducts[index];
              return _buildProductCard(product, index);
            },
          );
        }

        if (state is SearchError) {
          return _buildErrorState(state.message);
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppConfig.primaryColor),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(product, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppConfig.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow:
            AppConfig.shadowColor != null
                ? [
                  BoxShadow(
                    color: AppConfig.shadowColor,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
                : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            NavigationHelper.navigateToProductDetails(
              context,
              product,
              sizeType: SizeType.number,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Hero(
                  tag: 'product_${product.id}',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors:
                            AppConfig.gradientColors
                                .map((c) => c.withOpacity(0.1))
                                .toList(),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child:
                          product.images.isNotEmpty
                              ? Image.network(
                                product.images[0],
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        _buildFallbackImage(),
                              )
                              : _buildFallbackImage(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppTextStyles.productCardTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppConfig.secondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTextStyles.productCardPrice.copyWith(
                            color: AppConfig.secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: AppConfig.gradientColors),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppConfig.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_shopping_cart_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      // Add to cart logic
                      _showAddToCartSnackbar(product.name);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppConfig.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 60,
              color: AppConfig.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text("No products found", style: AppTextStyles.emptyStateTitle),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your search or filters",
            style: AppTextStyles.emptyStateSubtitle,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              size: 60,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Oops! Something went wrong",
            style: AppTextStyles.emptyStateTitle,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.emptyStateSubtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppConfig.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.image_not_supported_rounded,
        size: 32,
        color: AppConfig.primaryColor,
      ),
    );
  }

  void _showAddToCartSnackbar(String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName added to cart!'),
        backgroundColor: AppConfig.secondaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
