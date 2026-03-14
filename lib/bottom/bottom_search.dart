import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BottomSearchPage extends StatefulWidget {
  const BottomSearchPage({super.key});

  @override
  State<BottomSearchPage> createState() => _BottomSearchPageState();
}

class _BottomSearchPageState extends State<BottomSearchPage> {
  TextEditingController searchController = TextEditingController();
  Widget movieTile(BuildContext context, dynamic docs) {
    return ListTile(
      title: Text(docs['name']),
      subtitle: Text(docs['description'], maxLines: 3),
      leading: Image.network(docs['image']),
      trailing: IconButton(onPressed: () {}, icon: Icon(Icons.bookmark)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            filled: true,
            hintText: 'Поиск',
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {});
              },
            ),
            fillColor: Colors.white10,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.white10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.white10),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: Supabase.instance.client
            .from('movies')
            .stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            );
          }
          var movie = snapshot.data;
          if(searchController.text.isNotEmpty){
            movie = movie!.where((element) => element['name'.toLowerCase().contains(searchController.text.toLowerCase())]).toList();
          }
          return ListView.builder(
            itemCount: movie!.length,
            itemBuilder: (context, index) {
              return movieTile(context, movie![index]);
            },
          );
        },
      ),
    );
  }
}
