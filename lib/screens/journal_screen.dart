import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../models/journal.dart';

import '../providers/journal_provider.dart';
import '../widgets/custom_text_form_field.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _noteController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  DateTime selectedDate = DateTime.now();
  late List<DateTime> surroundingDates;
  String? _editingId;

  @override
  void initState() {
    super.initState();
    surroundingDates = _getSurroundingDates(selectedDate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JournalProvider>(context, listen: false)
          .fetchJournalsByDate(selectedDate);
      _scrollToCenterDate();
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<DateTime> _getSurroundingDates(DateTime centerDate) {
    return List.generate(
        15, (index) => centerDate.subtract(Duration(days: 7 - index)));
  }

  void _scrollToCenterDate() {
    final index = surroundingDates.indexWhere(
      (date) => DateUtils.isSameDay(date, selectedDate),
    );
    const double itemWidth = 70 + 14;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double offset =
        (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
    _scrollController.animateTo(
      offset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurpleAccent,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            iconButtonTheme: IconButtonThemeData(
                style: IconButton.styleFrom(foregroundColor: Colors.black54)),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurpleAccent,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        surroundingDates = _getSurroundingDates(picked);
      });
      Provider.of<JournalProvider>(context, listen: false)
          .fetchJournalsByDate(picked);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _scrollToCenterDate());
    }
  }

  void _saveJournal(BuildContext context) {
    final note = _noteController.text.trim();
    if (note.isEmpty) return;

    final provider = Provider.of<JournalProvider>(context, listen: false);
    if (_editingId != null) {
      final updated = Journal(
        id: _editingId!,
        note: note,
        date: selectedDate,
        time: DateTime.now(),
      );
      provider.addOrUpdateJournal(updated);
    } else {
      final newJournal = Journal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        note: note,
        date: selectedDate,
        time: DateTime.now(),
      );
      provider.addOrUpdateJournal(newJournal);
    }

    _noteController.clear();
    _editingId = null;

    provider.fetchJournalsByDate(selectedDate);
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Journal'),
        content: const Text('Are you sure you want to delete this journal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
          TextButton(
            onPressed: () {
              Provider.of<JournalProvider>(context, listen: false)
                  .deleteJournal(id, selectedDate);
              Provider.of<JournalProvider>(context, listen: false)
                  .fetchJournalsByDate(selectedDate);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
          icon: const Icon(CupertinoIcons.chevron_back),
        ),
        centerTitle: true,
        title: Text(
          'Journal',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        actions: [
          IconButton(
            onPressed: _chooseDate,
            tooltip: 'Choose date',
            icon: const Icon(CupertinoIcons.calendar_today),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 65,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: surroundingDates.length,
                itemBuilder: (context, index) {
                  final date = surroundingDates[index];
                  final isFuture = date.isAfter(DateTime.now());
                  final isSelected = DateUtils.isSameDay(date, selectedDate);

                  return GestureDetector(
                    onTap: () {
                      if (isFuture) return;
                      setState(() {
                        selectedDate = date;
                      });
                      Provider.of<JournalProvider>(context, listen: false)
                          .fetchJournalsByDate(date);
                      _scrollToCenterDate();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.all(10),
                      width: 70,
                      decoration: BoxDecoration(
                        color: isFuture
                            ? Theme.of(context).colorScheme.primaryContainer
                            : isSelected
                                ? Colors.deepPurpleAccent.withOpacity(0.2)
                                : Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(
                                color: Colors.deepPurpleAccent, width: 2)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(date),
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isFuture
                                  ? Colors.grey
                                  : isSelected
                                      ? Colors.deepPurpleAccent
                                      : null,
                            ),
                          ),
                          Text(
                            DateFormat('d MMM').format(date),
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isFuture
                                  ? Colors.grey
                                  : isSelected
                                      ? Colors.deepPurpleAccent
                                      : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            /// Journal List
            Expanded(
              child: Consumer<JournalProvider>(
                builder: (context, provider, _) {
                  final journals = provider.journals;
                  if (journals.isEmpty) {
                    return const Center(child: Text('No journals found.'));
                  }
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: journals.length,
                    itemBuilder: (context, index) {
                      final journal = journals[index];
                      final isFirst = index == 0;
                      final isLast = index == journals.length - 1;
                      return GestureDetector(
                        onLongPressStart: (details) {
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              details.globalPosition.dx,
                              details.globalPosition.dy,
                              details.globalPosition.dx,
                              details.globalPosition.dy,
                            ),
                            items: [
                              PopupMenuItem(
                                value: 'edit',
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit_note_rounded,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 10),
                                    Text('Edit'),
                                  ],
                                ),
                                onTap: () {
                                  Future.delayed(Duration.zero, () {
                                    setState(() {
                                      _editingId = journal.id;
                                      _noteController.text = journal.note;
                                    });
                                  });
                                },
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 10),
                                    Text('Delete'),
                                  ],
                                ),
                                onTap: () {
                                  Future.delayed(Duration.zero, () {
                                    _confirmDelete(context, journal.id);
                                  });
                                },
                              ),
                            ],
                          );
                        },
                        child: TimelineTile(
                          alignment: TimelineAlign.manual,
                          lineXY: 0.1,
                          isFirst: isFirst,
                          isLast: isLast,
                          indicatorStyle: const IndicatorStyle(
                            width: 20,
                            color: Colors.deepPurpleAccent,
                          ),
                          beforeLineStyle: const LineStyle(
                            color: Colors.deepPurpleAccent,
                            thickness: 2,
                          ),
                          endChild: Container(
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat.jm().format(journal.time),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (DateTime(
                                            journal.time.year,
                                            journal.time.month,
                                            journal.time.day) !=
                                        DateTime(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day))
                                      Text(
                                        DateFormat('d MMM, yyyy')
                                            .format(journal.time),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  journal.note,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            /// Input Field
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: _noteController,
                    keyboardType: TextInputType.multiline,
                    hintText:
                        _editingId != null ? 'Edit note...' : 'Add note...',
                    icon: Icons.sticky_note_2_outlined,
                    onFieldSubmitted: (_) => _saveJournal(context),
                  ),
                ),
                IconButton(
                  onPressed: () => _saveJournal(context),
                  tooltip: 'Save',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.lightGreen
                      : Colors.green,
                  icon: const Icon(Icons.send_rounded),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
