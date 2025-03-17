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

  @override
  void initState() {
    super.initState();
    // Load categories when the screen is loaded
    context.read<SearchBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                // Dispatch the search event when user types
                context.read<SearchBloc>().add(SearchProducts(query));
              },
              decoration: InputDecoration(
                labelText: 'Search for products',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is CategoriesLoaded) {
                  return Column(
                    children: [
                      Container(
                        height: 80.0, // Height of category list
                        child: ListView.builder(
                          itemCount: state.categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final category = state.categories[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Image.network(
                                      category.imageUrl,
                                      width: 60,
                                      height: 60,
                                    ),
                                    Text(category.name),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }

                if (state is ProductsLoaded) {
                  return ListView.builder(
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          leading: Image.network(product.imageUrl),
                          title: Text(product.name),
                          subtitle: Text(
                            'Price: \$${product.price.toStringAsFixed(2)}',
                          ),
                          trailing: Icon(Icons.shopping_cart),
                          onTap: () {
                            // Implement add to cart logic
                          },
                        ),
                      );
                    },
                  );
                }

                if (state is SearchError) {
                  return Center(child: Text(state.message));
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
