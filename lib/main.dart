import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mi App",
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> characters = [];
  bool isLoading = false;
  bool isCardLoading = false;
  int currentIndex = 0;
  int _selectedIndex = 0;

  Future<void> fetchCharacters() async {
    setState(() {
      isLoading = true;
    });

    final dio = Dio();

    try {
      final response = await dio.get('https://rickandmortyapi.com/api/character');

      if (response.statusCode == 200) {
        setState(() {
          characters = response.data['results'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Datos obtenidos exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusMessage}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateCardIndex(int newIndex) async {
    setState(() {
      isCardLoading = true;
    });

    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      currentIndex = newIndex;
      isCardLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recovery_Screen'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : characters.isEmpty
              ? Center(
                  child: ElevatedButton(
                    onPressed: fetchCharacters,
                    child: Text('Obtener personajes'),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: isCardLoading
                          ? Center(child: CircularProgressIndicator())
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CharacterDetail(character: characters[currentIndex]),
                                  ),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.network(characters[currentIndex]['image']),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        characters[currentIndex]['name'],
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text('Status: ${characters[currentIndex]['status']}'),
                                    Text('Species: ${characters[currentIndex]['species']}'),
                                    Text('Gender: ${characters[currentIndex]['gender']}'),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: currentIndex > 0
                              ? () => updateCardIndex(currentIndex - 1)
                              : null,
                          child: Text('Anterior'),
                        ),
                        ElevatedButton(
                          onPressed: currentIndex < characters.length - 1
                              ? () => updateCardIndex(currentIndex + 1)
                              : null,
                          child: Text('Siguiente'),
                        ),
                      ],
                    ),
                  ],
                ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            ).then((_) {
              setState(() {
                _selectedIndex = 0;
              });
            });
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Recovery',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class CharacterDetail extends StatelessWidget {
  final dynamic character;

  CharacterDetail({required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(character['image']),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  character['name'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Text('Status: ${character['status']}'),
              Text('Species: ${character['species']}'),
              Text('Gender: ${character['gender']}'),
              Text('Origin: ${character['origin']['name']}'),
            ],
          ),
        ),
      ),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Image.asset(
                'assets/63227.png',
                fit: BoxFit.cover,
              ),
            ),
            Text("Recuperación Corte 1"),
            Text("211218"),
            Text("Luis Adrián Pozo Gómez"),
            Text("Ingeniería en Software"),
            Text("Programación para Móviles 2"),
            Text("9B"),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.web, color: const Color.fromARGB(255, 186, 35, 35)),
                  iconSize: 30,
                  onPressed: () async {
                    final web = Uri.parse(
                        'https://github.com/luisadrianPOZOGOMEZ/Flutter_Morty-2.git');
                    if (await canLaunchUrl(web)) {
                      await launchUrl(web, mode: LaunchMode.externalApplication);
                    } else {
                      print('Could not launch $web');
                    }
                  },
                  tooltip: 'Repositorio',
                  splashColor: Colors.blueAccent,
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Recovery',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}