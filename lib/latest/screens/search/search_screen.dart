import 'package:demo_app/latest/components/base/custom_appbar.dart';
import 'package:demo_app/latest/screens/search/components/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(LoadData());
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

    // Ensure Bloc updates properly
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
      appBar: CustomAppBar(title: "Search"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 10),
            _buildCategoryChips(),
            const SizedBox(height: 10),
            Expanded(child: _buildProductList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (query) => _onSearch(),
      decoration: InputDecoration(
        labelText: 'Search for products',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            _searchController.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearch();
                  },
                )
                : null,
      ),
    );
  }

  Widget _buildCategoryChips() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchDataLoaded) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  state.categories.map((category) {
                    final isSelected = _selectedCategories.contains(
                      category.id,
                    );

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ChoiceChip(
                        label: Text(category.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          _onCategorySelected(category.id);
                        },
                        selectedColor: Colors.blueAccent,
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          );
        }

        return const SizedBox.shrink(); // Hide if no categories are available
      },
    );
  }

  Widget _buildProductList() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchDataLoaded) {
          if (state.displayedProducts.isEmpty) {
            return const Center(
              child: Text("No products found", style: TextStyle(fontSize: 16)),
            );
          }

          return ListView.builder(
            itemCount: state.displayedProducts.length,
            itemBuilder: (context, index) {
              final product = state.displayedProducts[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Optional: Add rounded corners
                    child:
                        product.images.isNotEmpty
                            ? Image.network(
                              product.images[0],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      _fallbackImage(),
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                  ),
                                );
                              },
                            )
                            : _fallbackImage(), // Show placeholder if no image is available
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Price: \$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.green),
                  ),
                  trailing: const Icon(Icons.shopping_cart, color: Colors.blue),
                  onTap: () {
                    // Implement add to cart logic
                  },
                ),
              );
            },
          );
        }

        if (state is SearchError) {
          return Center(
            child: Text(state.message, style: TextStyle(color: Colors.red)),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _fallbackImage() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey[300], // Light grey background
      child: const Icon(
        Icons.image_not_supported,
        size: 30,
        color: Colors.grey,
      ),
    );
  }
}
