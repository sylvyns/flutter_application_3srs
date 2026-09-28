import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

// функция для показа Toast-уведомлений
void showToast(String text) {
  Fluttertoast.showToast(msg: text);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мое приложение',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo, // основной цвет
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        // Одинаковый стиль заголовков
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Список из 10 товаров: Товар №1 ... Товар №10
  List<String> items = List.generate(10, (i) => 'Товар №${i + 1}');

  // Дополнительное задание
  void addItem() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Новый элемент'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Введите название'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  // setState перерисовывает экран с новым списком
                  setState(() {
                    items.add(controller.text);
                  });
                  showToast('Элемент добавлен');
                }
                Navigator.pop(dialogContext);
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // DefaultTabController связывает TabBar и TabBarView
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Мое приложение'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Список'),
              Tab(icon: Icon(Icons.grid_view), text: 'Сетка'),
            ],
          ),
        ),
        drawer: const MyDrawer(),
        body: TabBarView(
          children: [
            buildList(), // вкладка 1
            const GridTab(), // вкладка 2
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addItem,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Вкладка «Список»
  Widget buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.shopping_bag, color: Colors.indigo),
            title: Text(items[index]),
            subtitle: const Text('Описание товара'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showToast('Вы выбрали: ${items[index]} (элемент №${index + 1})');
            },
          ),
        );
      },
    );
  }
}

// ===================== ВКЛАДКА «СЕТКА» =====================

class GridTab extends StatefulWidget {
  const GridTab({super.key});

  @override
  State<GridTab> createState() => _GridTabState();
}

class _GridTabState extends State<GridTab> {
  // У каждого элемента свой цвет
  List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
  ];

  // Хранит, нажат элемент или нет
  List<bool> pressed = List.filled(6, false);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 элемента в ряду
        crossAxisSpacing: 12, // расстояние между элементами по горизонтали
        mainAxisSpacing: 12, // расстояние между элементами по вертикали
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // При нажатии меняем состояние -> меняется цвет
            setState(() {
              pressed[index] = !pressed[index];
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // Нажат -> зелёный, иначе свой цвет
              color: pressed[index] ? Colors.green : colors[index],
              borderRadius: BorderRadius.circular(16), // скругление
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ===================== БОКОВОЕ МЕНЮ (DRAWER) =====================

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Text(
              'Меню',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Главная'),
            onTap: () {
              Navigator.pop(context); // просто закрываем меню
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Профиль'),
            onTap: () {
              Navigator.pop(context);
              Navigator.22(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.style),
            title: const Text('Карточки'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CardsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Настройки'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Выход'),
            onTap: () {
              Navigator.pop(context);
              showToast('Выход из аккаунта');
            },
          ),
        ],
      ),
    );
  }
}



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.indigo,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text('Иван Иванов', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('ivan@example.com'),
              const SizedBox(height: 24),
              // Задание 6: кнопка «Показать приветствие»
              ElevatedButton(
                onPressed: () {
                  showToast('Hello, Flutter!');
                },
                child: const Text('Показать приветствие'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  double volume = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Уведомления'),
              value: notifications,
              onChanged: (value) {
                setState(() {
                  notifications = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Text('Громкость: ${volume.round()}'),
            Slider(
              value: volume,
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  volume = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showToast('Настройки сохранены');
                },
                child: const Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Product {
  final String name;
  final String description;
  final String details;
  final IconData icon;
  final Color color;

  const Product(this.name, this.description, this.details, this.icon, this.color);
}

const List<Product> products = [
  Product('Смартфон', 'Современный смартфон',
      'Экран 6.5 дюйма, камера 50 Мп, батарея 5000 мАч.', Icons.smartphone, Colors.blue),
  Product('Ноутбук', 'Мощный ноутбук для работы',
      'Процессор 8 ядер, 16 ГБ памяти, SSD 512 ГБ.', Icons.laptop, Colors.teal),
  Product('Наушники', 'Беспроводные наушники',
      'Bluetooth 5.3, шумоподавление, до 30 часов работы.', Icons.headphones, Colors.orange),
  Product('Часы', 'Умные часы',
      'Пульсометр, шагомер, уведомления со смартфона.', Icons.watch, Colors.purple),
];

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Карточки')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          Product product = products[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias, // чтобы картинка тоже была скруглённой
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // «Изображение» товара
                Container(
                  height: 120,
                  width: double.infinity,
                  color: product.color,
                  child: Icon(product.icon, size: 64, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(product.description),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(product: product),
                              ),
                            );
                          },
                          child: const Text('Подробнее'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class DetailScreen extends StatelessWidget {
  final Product product; // товар передаётся из экрана карточек

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(product.icon, size: 120, color: product.color),
            const SizedBox(height: 16),
            Text(product.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(product.details, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                showToast('${product.name} добавлен в корзину');
              },
              child: const Text('В корзину'),
            ),
          ],
        ),
      ),
    );
  }
}