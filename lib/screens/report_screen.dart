import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/sighting.dart';
import '../providers/sighting_provider.dart';
import '../utils/theme.dart';

class ReportScreen extends StatefulWidget {
  final VoidCallback onSubmitted;
  const ReportScreen({super.key, required this.onSubmitted});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
      // Camera might be unavailable (e.g. simulator) — fail quietly.
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
    context.read<SightingProvider>().addSighting(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      neighborhood: _neighborhoodController.text.trim(),
      threatLevel: _threatLevel,
      tags: _tags.toList(),
      photo: _photo,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tip filed! Thanks for keeping the city informed.'),
      ),
    );
    _titleController.clear();
    _descController.clear();
    _neighborhoodController.clear();
    setState(() {
      _threatLevel = ThreatLevel.curious;
      _tags.clear();
      _photo = null;
    });
    widget.onSubmitted();
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
    return Scaffold(
      appBar: AppBar(title: const Text('REPORT A SIGHTING')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
