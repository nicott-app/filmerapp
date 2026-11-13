import 'package:filmer/core/theme/app_colors.dart';
import 'package:filmer/models/filter_options.dart';
import 'package:filmer/models/movie.dart';
import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  final FilterOptions currentFilters;
  final Function(FilterOptions) onApply;

  const FilterSheet({
    super.key,
    required this.currentFilters,
    required this.onApply,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late ContentType? _selectedType;
  late List<String> _selectedPlatforms;
  late List<String> _selectedGenres;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.currentFilters.contentType;
    _selectedPlatforms = List.from(widget.currentFilters.selectedPlatforms);
    _selectedGenres = List.from(widget.currentFilters.selectedGenres);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildSectionTitle('Tipo de Contenido'),
                   const SizedBox(height: 12),
                   _buildTypeSelector(),
                   
                   const SizedBox(height: 24),
                   _buildSectionTitle('Plataformas'),
                   const SizedBox(height: 12),
                   _buildPlatformsGrid(),

                   const SizedBox(height: 24),
                   _buildSectionTitle('Géneros'),
                   const SizedBox(height: 12),
                   _buildGenresWrap(),
                ],
              ),
            ),
          ),
          _buildApplyButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Filtros', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        Expanded(child: _buildTypeOption('Todos', null)),
        const SizedBox(width: 8),
        Expanded(child: _buildTypeOption('Películas', ContentType.movie)),
        const SizedBox(width: 8),
        Expanded(child: _buildTypeOption('Series', ContentType.series)),
      ],
    );
  }

  Widget _buildTypeOption(String label, ContentType? value) {
    final isSelected = _selectedType == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.withValues(alpha: 0.2),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformsGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: availablePlatforms.map((platform) {
        final isSelected = _selectedPlatforms.contains(platform.name);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedPlatforms.remove(platform.name);
              } else {
                _selectedPlatforms.add(platform.name);
              }
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white, // Logos usually look better on white or need specific handling
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 3,
                  ),
                ),
                padding: const EdgeInsets.all(8),
                // Simple network image for prototype, ideally cached or asset
                child: Image.network(
                  platform.logoUrl, 
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.tv, color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                platform.name,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? AppColors.primary : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenresWrap() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableGenres.map((genre) {
        final isSelected = _selectedGenres.contains(genre);
        return FilterChip(
          label: Text(genre),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedGenres.add(genre);
              } else {
                _selectedGenres.remove(genre);
              }
            });
          },
          selectedColor: AppColors.primary.withValues(alpha: 0.2),
          checkmarkColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primary : Theme.of(context).colorScheme.onSurface,
          ),
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0,
          side: BorderSide(
             color: isSelected ? AppColors.primary : Colors.grey.withValues(alpha: 0.2),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              widget.onApply(FilterOptions(
                contentType: _selectedType,
                selectedPlatforms: _selectedPlatforms,
                selectedGenres: _selectedGenres,
              ));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Aplicar Filtros', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}

