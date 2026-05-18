// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/habit_provider.dart';
// import '../models/habit_model.dart';
// import '../utils/catagory.dart';
// import '../utils/utility_fun.dart';

// class HabitHomeScreen extends StatefulWidget {
//   const HabitHomeScreen({super.key});

//   @override
//   State<HabitHomeScreen> createState() => _HabitHomeScreenState();
// }

// class _HabitHomeScreenState extends State<HabitHomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       context.read<HabitProvider>().loadHabits();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<HabitProvider>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             provider.isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : SingleChildScrollView(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 20),

//                         // HEADER
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Good Morning',
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blue[700],
//                               ),
//                             ),
//                             Text(
//                               getTodayDate(),
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 25),

//                         // SEARCH
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[100],
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: const TextField(
//                             decoration: InputDecoration(
//                               icon: Icon(Icons.search, color: Colors.grey),
//                               hintText: 'Search habits...',
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 25),

//                         // CATEGORY CHIPS
//                         SizedBox(
//                           height: 45,
//                           child: ListView(
//                             scrollDirection: Axis.horizontal,
//                             children: [
//                               _buildChip(
//                                 "All",
//                                 provider.selectedCategory == null,
//                                 () => provider.setCategory(null),
//                               ),
//                               _buildChip(
//                                 "Study",
//                                 provider.selectedCategory == Category.study,
//                                 () => provider.setCategory(Category.study),
//                               ),
//                               _buildChip(
//                                 "Health",
//                                 provider.selectedCategory == Category.health,
//                                 () => provider.setCategory(Category.health),
//                               ),
//                               _buildChip(
//                                 "Fitness",
//                                 provider.selectedCategory == Category.fitness,
//                                 () => provider.setCategory(Category.fitness),
//                               ),
//                               _buildChip(
//                                 "Spiritual",
//                                 provider.selectedCategory == Category.spiritual,
//                                 () => provider.setCategory(Category.spiritual),
//                               ),
//                               _buildChip(
//                                 "Productivity",
//                                 provider.selectedCategory ==
//                                     Category.productivity,
//                                 () =>
//                                     provider.setCategory(Category.productivity),
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 20),

//                         // ======================
//                         // TODAY SECTION
//                         // ======================
//                         _sectionTitle(
//                           "Today's Habits",
//                           '${completionPercentage(provider.todayHabits)}% Done',
//                         ),

//                         const SizedBox(height: 10),

//                         _buildTodaySection(provider),

//                         const SizedBox(height: 30),

//                         // ======================
//                         // ALL SECTION
//                         // ======================
//                         const Text(
//                           "All Habits",
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),

//                         const SizedBox(height: 15),

//                         _buildAllSection(provider),

//                         const SizedBox(height: 100),
//                       ],
//                     ),
//                   ),

//             // FAB
//             Positioned(
//               right: 20,
//               bottom: 90,
//               child: FloatingActionButton(
//                 onPressed: () {},
//                 backgroundColor: const Color(0xFF2F54EB),
//                 child: const Icon(Icons.add, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ======================
//   // TODAY SECTION WIDGET
//   // ======================
//   Widget _buildTodaySection(HabitProvider provider) {
//     final habits = provider.filteredTodayHabits;

//     if (habits.isEmpty) {
//       return Padding(
//         padding: const EdgeInsets.all(10),
//         child: Text(
//           provider.selectedCategory == null
//               ? "No habits for today"
//               : "No ${provider.selectedCategory!.name} habits today",
//           style: const TextStyle(color: Colors.grey),
//         ),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: habits.length,
//       itemBuilder: (context, index) {
//         final habit = habits[index];

//         return ListTile(
//           title: Text(habit.title),
//           subtitle: Text(habit.message ?? ""),
//           trailing: Checkbox(
//             value: habit.isCompletedToday,
//             onChanged: (_) => provider.toggleHabit(habit),
//           ),
//         );
//       },
//     );
//   }

//   // ======================
//   // ALL SECTION WIDGET
//   // ======================
//   Widget _buildAllSection(HabitProvider provider) {
//     final habits = provider.filteredAllHabits;

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: habits.length,
//       itemBuilder: (context, index) {
//         final habit = habits[index];

//         return Card(
//           child: ListTile(
//             title: Text(habit.title),
//             subtitle: Text(habit.category.name),

//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => provider.deleteHabit(habit.id),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _sectionTitle(String title, String subtitle) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           subtitle,
//           style: TextStyle(
//             color: Colors.blue[600],
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildChip(String label, bool selected, VoidCallback onTap) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 10),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//           decoration: BoxDecoration(
//             color: selected ? Colors.blue : Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Text(
//             label,
//             style: TextStyle(
//               color: selected ? Colors.white : Colors.black,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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

                        // ================= TODAY =================
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

                        // ================= ALL =================
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

  // ================= TODAY (KEEP YOUR CARD DESIGN) =================
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

  // ================= ALL (EDIT + DELETE ONLY HERE) =================
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
