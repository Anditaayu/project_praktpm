import 'package:flutter/material.dart';
import 'package:project_tpm/view/page_detail_books.dart';
import '../controller/api_data_source.dart';
import '../model/books_list.dart';

class PageListBooks extends StatefulWidget {
  final String text;
  const PageListBooks({Key? key, required this.text}) : super(key: key);

  @override
  State<PageListBooks> createState() => _PageListBooksState();
}

class _PageListBooksState extends State<PageListBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book List"),
      ),
      body: _buildListUsersBody(),
    );
  }

  Widget _buildListUsersBody() {
    return Container(
      child: FutureBuilder(
        future: ApiDataSource.instance.loadListBook(widget.text),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            // Jika data ada error maka akan ditampilkan hasil error
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            // Jika data ada dan berhasil maka akan ditampilkan hasil datanya
            BookList bookModel = BookList.fromJson(snapshot.data);
            return _buildSuccessSection(bookModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildErrorSection() {
    return const Text("Error");
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(BookList bookModel) {
    return ListView.builder(
      itemCount: bookModel.books!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemUsers(bookModel.books![index]);
      },
    );
  }

  Widget _buildItemUsers(Books book) {
    return InkWell(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PageDetailBooks(id: book.id!)))
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Image.network(book.image!),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(book.title!), Text(book.authors!)],
            ),
          ],
        ),
      ),
    );
  }
}
