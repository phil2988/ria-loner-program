import 'package:flutter/material.dart';

import 'loan_category.dart';
import 'loan_item.dart';

class LoanItemList extends StatefulWidget {
  const LoanItemList({super.key, required this.setLoanItems});

  final Function(List<LoanItem>) setLoanItems;

  @override
  State<LoanItemList> createState() => _LoanItemListState();
}

class _LoanItemListState extends State<LoanItemList> {
  final items = <LoanItem>[];

  updateItems() {
    widget.setLoanItems(items);
  }

  @override
  Widget build(BuildContext context) {
    widget.setLoanItems(items);
    return Column(children: [
      Row(
        children: [
          const Text("Loan items",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Spacer(),
          IconButton(
              onPressed: () => setState(() {
                    if (items.isNotEmpty) {
                      items.removeLast();
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Add an item before trying removing an item")));
                  }),
              icon: const Icon(Icons.remove)),
          IconButton(
              onPressed: () => setState(() {
                    if (items.length < 3) {
                      items.add(LoanItem());
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text("Maximum 3 items can be lent out at once")));
                  }),
              icon: const Icon(Icons.add)),
        ],
      ),
      const Divider(),
      for (var item in items) ...[
        LoanItemDisplay(
          updateItems: updateItems,
          index: items.indexOf(item),
          item: item,
          allItems: items,
          removeItem: () => setState(() => {
                items.remove(item),
              }),
        )
      ],
    ]);
  }
}

class LoanItemDisplay extends StatefulWidget {
  const LoanItemDisplay({
    super.key,
    required this.item,
    required this.removeItem,
    required this.allItems,
    required this.index,
    required this.updateItems,
  });

  final VoidCallback updateItems;
  final VoidCallback removeItem;
  final LoanItem item;
  final int index;
  final List<LoanItem> allItems;

  @override
  State<LoanItemDisplay> createState() => _LoanItemDisplayState();
}

class _LoanItemDisplayState extends State<LoanItemDisplay> {
  final key = GlobalKey<_LoanItemDisplayState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: constraints.maxWidth * 0.5,
              child: TextFormField(
                initialValue: widget.item.name,
                decoration: const InputDecoration(
                  hintText: "Enter name",
                ),
                onChanged: (value) {
                  setState(() {
                    widget.allItems[widget.index].name = value;
                    widget.updateItems();
                  });
                },
              )),
          SizedBox(
            width: constraints.maxWidth * 0.4,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<LoanCategory>(
                hint: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Select category"),
                ),
                value: widget.item.category,
                onChanged: (LoanCategory? newValue) {
                  setState(() {
                    widget.allItems[widget.index].category = newValue!;
                    widget.updateItems();
                  });
                },
                items: LoanCategory.values.map<DropdownMenuItem<LoanCategory>>(
                  (LoanCategory value) {
                    return DropdownMenuItem<LoanCategory>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(value.toString()),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      );
    });
  }
}
