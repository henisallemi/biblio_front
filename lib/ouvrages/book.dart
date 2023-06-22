import 'package:flutter/material.dart';

void main() {
  runApp(BookListApp());
}

class Book {
  final String title;
  final String author;

  Book(this.title, this.author);
}

class BookListApp extends StatelessWidget {
  final List<Book> books = [
    Book('Harry Potter and the Sorcerer\'s Stone', 'J.K. Rowling'),
    Book('To Kill a Mockingbird', 'Harper Lee'),
    Book('The Great Gatsby', 'F. Scott Fitzgerald'),
    Book('1984', 'George Orwell'),
    Book('Pride and Prejudice', 'Jane Austen'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Book List'),
        ),
        body: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(books[index].title),
              subtitle: Text(books[index].author),
            );
          },
        ),
      ),
    );
  }
}
