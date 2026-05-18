import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/habit_model.dart';
import '../utils/catagory.dart'; // Adjust path based on your folder structure

class EditHabitScreen extends StatefulWidget {
  final Habit habit;
  final Future<void> Function(Habit) onUpdateHabit;

  const EditHabitScreen({
    super.key,
    required this.habit,
    required this.onUpdateHabit,
  });

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _messageController;
  late Category _selectedCategory;
  late Set<String> _selectedDays;
  DateTime? _selectedEndDate;
  bool _isLoading = false;

  // Make sure these IDs match your backend exactly (e.g., 'Monday' vs 'Mon')
  final List<Map<String, String>> _daysList = [
    {'label': 'S', 'id': 'Sunday'},
    {'label': 'M', 'id': 'Monday'},
    {'label': 'T', 'id': 'Tuesday'},
    {'label': 'W', 'id': 'Wednesday'},
    {'label': 'T', 'id': 'Thursday'},
    {'label': 'F', 'id': 'Friday'},
    {'label': 'S', 'id': 'Saturday'},
  ];

  @override
  void initState() {
    super.initState();
    // Pre-populate fields with existing habit data
    _titleController = TextEditingController(text: widget.habit.title);
    _messageController = TextEditingController(
      text: widget.habit.message ?? '',
    );
    _selectedCategory = widget.habit.category;
    _selectedDays = Set<String>.from(widget.habit.repeatDays);
    _selectedEndDate = widget.habit.endDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _selectedEndDate = picked);
    }
  }

  void _submitUpdate() {
    if (_titleController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    // Use copyWith to update properties while maintaining the existing ID and meta data
    final updatedHabit = widget.habit.copyWith(
      title: _titleController.text.trim(),
      category: _selectedCategory,
      repeatDays: _selectedDays.toList(),
      message: _messageController.text.trim().isEmpty
          ? null
          : _messageController.text.trim(),
      endDate: _selectedEndDate,
    );

    widget
        .onUpdateHabit(updatedHabit)
        .then((_) {
          Navigator.pop(context);
        })
        .catchError((error) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3352D5);
    const labelStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF3A3A3C),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Habit',
          style: TextStyle(
            color: Color(0xFF1C1C1E),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Habit Title
            const Text('Habit Title', style: labelStyle),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Category Selection Block
            const Text('Category', style: labelStyle),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: Category.values.map((cat) {
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(
                    cat.name.substring(0, 1).toUpperCase() +
                        cat.name.substring(1),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1C1C1E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: primaryColor,
                  backgroundColor: Colors.white,
                  avatar: CircleAvatar(
                    radius: 5,
                    backgroundColor: isSelected
                        ? Colors.white
                        : getCategoryColor(cat).withOpacity(0.4),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? primaryColor
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  showCheckmark: false,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedCategory = cat);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Days Selection Block
            const Text('Repeat on', style: labelStyle),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _daysList.map((day) {
                  final isSelected = _selectedDays.contains(day['id']);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected
                            ? _selectedDays.remove(day['id'])
                            : _selectedDays.add(day['id']!);
                      });
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? primaryColor
                            : const Color(0xFFF8FAFC),
                        // border: BorderSide(color: isSelected ? primaryColor : const Color(0xFFE2E8F0)),
                      ),
                      child: Center(
                        child: Text(
                          day['label']!,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF4A4A4A),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Optional End Date Picker Block
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('End Date (Optional)', style: labelStyle),
                Text(
                  'Until completed',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedEndDate == null
                          ? 'mm/dd/yyyy'
                          : DateFormat('MM/dd/yyyy').format(_selectedEndDate!),
                      style: TextStyle(
                        color: _selectedEndDate == null
                            ? const Color(0xFF3A3A3C).withOpacity(0.6)
                            : const Color(0xFF1C1C1E),
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 18,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Reminder Message Input Field Block
            const Text('Reminder Message', style: labelStyle),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 32),

            // Dynamic Action Button Label Block
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline, size: 22),
                label: const Text(
                  'Update Habit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
