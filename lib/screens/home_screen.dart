import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../utils/catagory.dart';
import '../utils/utility_fun.dart';
import '../widgets/catagory_chip.dart';

class HabitHomeScreen extends StatefulWidget {
  const HabitHomeScreen({super.key});

  @override
  State<HabitHomeScreen> createState() => _HabitHomeScreenState();
}

class _HabitHomeScreenState extends State<HabitHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HabitProvider>().loadHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // HEADER
                        Text(
                          'Small Steps. Let’s Go!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        Text(
                          getTodayDate(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 25),

                        // SEARCH
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.search, color: Colors.grey),
                              hintText: 'Search habits...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // CATEGORY CHIPS
                        SizedBox(
                          height: 45,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              chip(
                                "All",
                                provider.selectedCategory == null,
                                () => provider.setCategory(null),
                              ),
                              chip(
                                "Study",
                                provider.selectedCategory == Category.study,
                                () => provider.setCategory(Category.study),
                              ),
                              chip(
                                "Health",
                                provider.selectedCategory == Category.health,
                                () => provider.setCategory(Category.health),
                              ),
                              chip(
                                "Fitness",
                                provider.selectedCategory == Category.fitness,
                                () => provider.setCategory(Category.fitness),
                              ),
                              chip(
                                "Spiritual",
                                provider.selectedCategory == Category.spiritual,
                                () => provider.setCategory(Category.spiritual),
                              ),
                              chip(
                                "Productivity",
                                provider.selectedCategory ==
                                    Category.productivity,
                                () =>
                                    provider.setCategory(Category.productivity),
                              ),
                              chip(
                                "Others",
                                provider.selectedCategory == Category.others,
                                () => provider.setCategory(Category.others),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Today's Habits",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${provider.todayProgress.toStringAsFixed(0)}% Done",
                              style: TextStyle(
                                color: Colors.blue[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        _buildToday(provider),

                        const SizedBox(height: 30),

                        const Text(
                          "All Habits",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        _buildAll(provider),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),

            // FLOATING BUTTON
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF2F54EB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  //today habit list

  Widget _buildToday(HabitProvider provider) {
    final habits = provider.todayHabits;

    if (habits.isEmpty) {
      return Text(
        provider.selectedCategory == null
            ? "No habits for today"
            : "No habits in this category today",
        style: const TextStyle(color: Colors.grey),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Material(
            color: getCategoryColor(habit.category).withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => provider.toggleHabit(habit),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(habit.message ?? ""),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: habit.isCompletedToday,
                      onChanged: (_) => provider.toggleHabit(habit),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //all habits list

  Widget _buildAll(HabitProvider provider) {
    final habits = provider.filteredAllHabits;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Material(
            color: getCategoryColor(habit.category).withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),

              title: Text(
                habit.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                habit.category.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: getCategoryColor(habit.category),
                ),
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blueGrey),
                    onPressed: () {},
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => provider.deleteHabit(habit.id),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
