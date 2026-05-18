import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this to your pubspec.yaml for date formatting

// Assuming these are imported from your project paths
import '../utils/catagory.dart';
import '../models/habit_model.dart';

class AddHabitScreen extends StatefulWidget {
  final Future<Habit> Function(Habit) onCreateHabit;

  const AddHabitScreen({super.key, required this.onCreateHabit});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  Category _selectedCategory = Category.study;

  // Maps the day labels to API strings: 'S', 'M', 'T', 'W', 'T', 'F', 'S'
  // Using explicit unique IDs for duplicate days like Sunday/Saturday vs Tuesday/Thursday
  final List<Map<String, String>> _daysList = [
    {'label': 'S', 'id': 'Sun'},
    {'label': 'M', 'id': 'Mon'},
    {'label': 'T', 'id': 'Tue'},
    {'label': 'W', 'id': 'Wed'},
    {'label': 'T', 'id': 'Thu'},
    {'label': 'F', 'id': 'Fri'},
    {'label': 'S', 'id': 'Sat'},
  ];
  final Set<String> _selectedDays = {
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
  }; // Default selection from UI

  DateTime? _selectedEndDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _selectedEndDate = picked);
    }
  }

  void _submitHabit() {
    if (_titleController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    final newHabit = Habit(
      id: '', // Handled by backend, or generate UUID here
      title: _titleController.text.trim(),
      category: _selectedCategory,
      repeatDays: _selectedDays.toList(),
      createdAt: DateTime.now().toIso8601String(),
      message: _messageController.text.trim().isEmpty
          ? null
          : _messageController.text.trim(),
      endDate: _selectedEndDate,
    );

    widget
        .onCreateHabit(newHabit)
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
          'New Habit',
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
                hintText: 'e.g. Meditate',
                hintStyle: const TextStyle(
                  color: Color(0xFFCCDDFF), // Corrected hex code
                  fontSize: 15,
                ),
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

            // Category
            const Text('Category', style: labelStyle),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: Category.values.map((cat) {
                final isSelected = _selectedCategory == cat;
                final baseColor = getCategoryColor(cat);

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
                        : baseColor.withOpacity(0.4),
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

            // Repeat On
            const Text('Repeat on', style: labelStyle),
            const SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                // border: BorderSide(color: Color(0xFFF1F5F9)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _daysList.map((day) {
                  final isSelected = _selectedDays.contains(day['id']);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedDays.remove(day['id']);
                        } else {
                          _selectedDays.add(day['id']!);
                        }
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
                        // border: BorderSide(
                        //   color: isSelected ? primaryColor : const Color(0xFFE2E8F0),
                        // ),
                      ),
                      child: Center(
                        key: ValueKey(day['id']),
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

            // End Date
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

            // Reminder Message
            const Text('Reminder Message', style: labelStyle),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write a small note to your future self...',
                hintStyle: TextStyle(
                  color: const Color(0xFF3A3A3C).withOpacity(0.3),
                  fontSize: 14,
                ),
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

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitHabit,
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
                  'Save Habit',
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
