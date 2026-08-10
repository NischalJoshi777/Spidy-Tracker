import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/sighting.dart';
import '../providers/sighting_provider.dart';
import '../utils/theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LatLng _cityCenter = const LatLng(40.7128, -74.0060);

  @override
  Widget build(BuildContext context) {
    final sightings = context.watch<SightingProvider>().sightings;

    return Scaffold(
      appBar: AppBar(title: const Text('CITY MAP')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _cityCenter,
              initialZoom: 13,
              minZoom: 4,
              maxZoom: 18,
              onTap: (_, latlng) => _showAddSightingSheet(context, latlng),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.spiderman_app',
              ),
              MarkerLayer(
                markers: sightings.map((s) {
                  return Marker(
                    point: LatLng(s.latitude, s.longitude),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _showDetails(context, s),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                          'assets/images/embeded_spidy_marker.png',
                          width: 34,
                          height: 34,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Tap anywhere on the map to report a sighting',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, Sighting s) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        s.threatLevel.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.grey.shade700,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  s.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      s.neighborhood,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  s.description,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
                if (s.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: s.tags
                        .map(
                          (t) => Chip(
                            label: Text(
                              '${t.emoji} ${t.label}',
                              style: const TextStyle(fontSize: 11),
                            ),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: AppColors.paper,
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      'by ${s.reporterName}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.verified, size: 16, color: Colors.blue.shade700),
                    const SizedBox(width: 4),
                    Text(
                      '${s.verifiedCount} confirmed',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddSightingSheet(BuildContext context, LatLng location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: FractionallySizedBox(
            widthFactor: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(sheetContext).size.height * 0.75,
              ),
              child: _AddSightingSheet(
                location: location,
                onSubmit:
                    (title, description, neighborhood, level, tags, photo) {
                  context.read<SightingProvider>().addSighting(
                    title: title,
                    description: description,
                    neighborhood: neighborhood,
                    threatLevel: level,
                    tags: tags,
                    latitude: location.latitude,
                    longitude: location.longitude,
                    photo: photo,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AddSightingSheet extends StatefulWidget {
  final LatLng location;
  final void Function(
    String title,
    String description,
    String neighborhood,
    ThreatLevel threatLevel,
    List<PowerTag> tags,
    File? photo,
  )
  onSubmit;

  const _AddSightingSheet({required this.location, required this.onSubmit});

  @override
  State<_AddSightingSheet> createState() => _AddSightingSheetState();
}

class _AddSightingSheetState extends State<_AddSightingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  ThreatLevel _threatLevel = ThreatLevel.curious;
  final Set<PowerTag> _tags = {};
  File? _photo;

  Future<void> _pickPhoto() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );
      if (picked != null) {
        setState(() => _photo = File(picked.path));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera not available on this device/simulator.'),
          ),
        );
      }
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_tags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick at least one activity tag.')),
      );
      return;
    }
    widget.onSubmit(
      _titleController.text.trim(),
      _descController.text.trim(),
      _neighborhoodController.text.trim(),
      _threatLevel,
      _tags.toList(),
      _photo,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tip filed! Thanks for keeping the city informed.'),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _neighborhoodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.86,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Report Sighting',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${widget.location.latitude.toStringAsFixed(4)}, ${widget.location.longitude.toStringAsFixed(4)}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                  image: _photo != null
                      ? DecorationImage(
                          image: FileImage(_photo!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _photo == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 36, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Tap to attach a photo',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Headline',
                hintText: 'e.g. Web-line spotted downtown',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Give it a short headline'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _neighborhoodController,
              decoration: const InputDecoration(
                labelText: 'Neighborhood / cross streets',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Where did this happen?'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'What did you see?',
                alignLabelWithHint: true,
              ),
              validator: (v) => (v == null || v.trim().length < 10)
                  ? 'A few more details, please'
                  : null,
            ),
            const SizedBox(height: 20),
            const Text(
              'How big a deal was it?',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: ThreatLevel.values.map((level) {
                return ChoiceChip(
                  label: Text(
                    level.label,
                    style: const TextStyle(fontSize: 12),
                  ),
                  selected: _threatLevel == level,
                  selectedColor: AppColors.heroRed,
                  labelStyle: TextStyle(
                    color: _threatLevel == level
                        ? Colors.white
                        : Colors.black87,
                  ),
                  onSelected: (_) => setState(() => _threatLevel = level),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'What did they do? (pick all that apply)',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PowerTag.values.map((tag) {
                final selected = _tags.contains(tag);
                return FilterChip(
                  label: Text(
                    '${tag.emoji} ${tag.label}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  selected: selected,
                  onSelected: (v) =>
                      setState(() => v ? _tags.add(tag) : _tags.remove(tag)),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.send),
              label: const Text('Submit Tip'),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '+ reporter points for every tip filed',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
