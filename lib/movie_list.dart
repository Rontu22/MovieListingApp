import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie_details.dart';


class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() {
   return new _MovieListState();
  }
}

class _MovieListState extends State<MovieList> {

  Color mainColor = const Color(0xff3c3261);

  // api request key
  // ex : http://api.themoviedb.org/3/discover/movie?api_key=fa2d4102bb728cd6dd954969014ab85a
  Future<Map> getJson() async{
    var url = "http://api.themoviedb.org/3/discover/movie?api_key=fa2d4102bb728cd6dd954969014ab85a";
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  var movies;
  void getData() async{
    var data = await getJson();
     setState(() {
       movies = data['results'];
     });
  }


  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 0.3,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: new Icon(
          Icons.arrow_back,
          color: mainColor,
        ),
        title: new Text(
          "Movies",
          style: new TextStyle(
            color: mainColor,
            fontFamily: "Arvo",
            fontWeight: FontWeight.bold
          ),
        ),
        actions: <Widget>[
          new Icon(
            Icons.menu,
            color: mainColor,
          )
        ],
      ),
      body: new Padding(padding: const EdgeInsets.all(16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new MovieTitle(mainColor),
          new Expanded(
              child:new ListView.builder(
                itemCount: movies == null ? 0 : movies.length,
                itemBuilder: (context,countMovies)
                {
                  return new FlatButton(
                    onPressed: (){
                      Navigator.push(context,new MaterialPageRoute(builder: (context){
                        return new MovieDetail(movies[countMovies]);
                      }));
                    },
                    child: new MovieCell(movies,countMovies),
                  padding: const EdgeInsets.all(0.0),
                  color: Colors.white,);
                },
              ) )
        ],
      ),),
    );
  }
}

class MovieTitle extends StatelessWidget {

  final Color mainColor;

  MovieTitle(this.mainColor);

  @override
  Widget build(BuildContext context) {
    return new Padding(padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    child: new Text(
      "Top Rated",
      style: new TextStyle(
        fontSize: 40.0,
        color: mainColor,
        fontWeight: FontWeight.bold,
        fontFamily: "Arvo"
      ),
      textAlign: TextAlign.left,
    ),
    );
  }
}

class MovieCell extends StatelessWidget {

  final movies;
  final countMovies;
  Color mainColor = const Color(0xff3c3261);
  var image_url = "https://image.tmdb.org/t/p/w500/";
  MovieCell(this.movies,this.countMovies);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Padding(padding: const EdgeInsets.all(0.0),
            child: new Container(
              margin: const EdgeInsets.all(16.0),
              child: new Container(
                width: 70.0,
                height: 70.0,
              ),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10.0),
                color: Colors.grey,
                image: new DecorationImage(
                  image: new NetworkImage(
                    image_url+movies[countMovies]['poster_path']
                  ),
                  fit: BoxFit.cover
                ),
                boxShadow: [
                  new BoxShadow(
                    color: mainColor,
                    blurRadius: 5.0,
                    offset: new Offset(2.0, 5.0),
                  ),
                ],
              ),
            ),),
            new Expanded(
                child: new Container(
                  margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: new Column(
                    children: [
                      new Text(
                        movies[countMovies]['title'],
                        style: new TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Arvo',
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                      new Padding(padding: const EdgeInsets.all(2.0)),
                      new Text(movies[countMovies]['overview'],
                      maxLines: 3,
                      style: new TextStyle(
                        color: const Color(0xff8785A4),
                        fontFamily: "Arvo"
                      ),)
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ) )
          ],
        ),
        new Container(
          width: 300.0,
          height: 0.5,
          color: const Color(0xD2D2E1ff),
          margin: const EdgeInsets.all(16.0),
        )
      ],
    );
  }
}


