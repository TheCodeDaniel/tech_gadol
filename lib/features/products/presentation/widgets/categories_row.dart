import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_gadol/core/widgets/category_chip.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_bloc.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_events.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_state.dart';

class CategoriesRow extends StatelessWidget {
  const CategoriesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      buildWhen: (prev, curr) =>
          prev.categories != curr.categories ||
          prev.selectedCategory != curr.selectedCategory,
      builder: (context, state) {
        if (state.categories.isEmpty) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return CategoryChip(
                label: category,
                isSelected:
                    state.selectedCategory == category,
                onTap: () {
                  context
                      .read<ProductsBloc>()
                      .add(SelectCategory(category));
                },
              );
            },
          ),
        );
      },
    );
  }
}
