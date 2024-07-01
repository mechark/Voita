// import 'package:flutter/material.dart';
// import 'package:voita_app/features/notes-overview/models/note_model.dart';

// class VoitaSearchDelegate extends SearchDelegate<Note> {
  
//   final List<Note> searchList;
//   VoitaSearchDelegate({required this.searchList});

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear_all),
//         onPressed: ()  {
//           query = '';
//         }
//       )
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.search),
//       onPressed: () => {},
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final searchResults = searchList.where(
//       (note) => note.header.toLowerCase().contains(query.toLowerCase()) || 
//         note.text.toLowerCase().contains(query.toLowerCase())
//     ).toList();

//     return ListView.builder(
//       itemCount: searchResults.length,
//       itemBuilder: (context, index) {
//         return ListTile()
//       }
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // Build the search suggestions.
//   }
// }