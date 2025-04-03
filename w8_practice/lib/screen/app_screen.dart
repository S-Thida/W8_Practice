import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/model/fruit.dart';
import '/screen/provider/fruit_provider.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

  void _onAddPressed(BuildContext context) {
    final FruitProvider fruitProvider = context.read<FruitProvider>();
    fruitProvider.addFruit("Coconut", 5.5);
  }

  void _onRemovePressed(BuildContext context, String fruitId) {
    final FruitProvider fruitProvider = context.read<FruitProvider>();
    fruitProvider.removeFruit(fruitId);
  }

  void _onEditPressed(BuildContext context, Fruit fruit) {
    showDialog(
      context: context,
      builder: (context) => _EditFruitDialog(fruit: fruit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fruitProvider = Provider.of<FruitProvider>(context);

    Widget content = const Text('');

    if (fruitProvider.isLoading) {
      content = const CircularProgressIndicator();
    } else if (fruitProvider.hasData) {
      List<Fruit> fruits = fruitProvider.fruitsState!.data!;

      if (fruits.isEmpty) {
        content = const Text("No data yet");
      } else {
        content = ListView.builder(
          itemCount: fruits.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(fruits[index].name),
            subtitle: Text("${fruits[index].price}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _onEditPressed(context, fruits[index]),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _onRemovePressed(context, fruits[index].id),
                ),
              ],
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Fruit Market'),
        actions: [
          IconButton(
            onPressed: () => _onAddPressed(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(child: content),
    );
  }
}
// For edit form
class _EditFruitDialog extends StatefulWidget {
  final Fruit fruit;

  const _EditFruitDialog({required this.fruit});

  @override
  __EditFruitDialogState createState() => __EditFruitDialogState();
}

class __EditFruitDialogState extends State<_EditFruitDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fruit.name);
    _priceController = TextEditingController(text: widget.fruit.price.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fruitProvider = Provider.of<FruitProvider>(context);

    return AlertDialog(
      title: const Text('Edit Fruit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Fruit Name'),
          ),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedFruit = Fruit(
              id: widget.fruit.id,
              name: _nameController.text,
              price: double.parse(_priceController.text),
            );
            fruitProvider.updateFruit(updatedFruit);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}