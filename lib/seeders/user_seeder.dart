import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserSeeder {
  var usersList = [
    {
      'auth': {'email': "arthur@gmail.com", 'password': "azerty"},
      'photo': {
        'fileName': "arthur.jpg",
      },
      'profile': {
        'name': "Arthur",
        'location': GeoPoint(45.774787, 4.869068),
        'gender': "m",
        'interestedIn': "f",
        'birthdate': DateTime.utc(1999, 05, 06),
        'maxDistance': 30,
        'minAge': 18,
        'maxAge': 25,
        'bio':
            "Je suis un petit gars propre et bien élevé, ta mère va m'adorer."
      }
    },
    {
      'auth': {'email': "diego@gmail.com", 'password': "azerty"},
      'photo': {
        'fileName': "diego.jpg",
      },
      'profile': {
        'name': "Diego",
        'location': GeoPoint(45.782552, 4.878497),
        'gender': "m",
        'interestedIn': "f",
        'birthdate': DateTime.utc(1998, 11, 19),
        'maxDistance': 30,
        'minAge': 18,
        'maxAge': 25,
        'bio':
            "La semaine dernière à New York, le mois prochain à Istanbul. Si toi aussi tu as l’âme voyageuse, viens donc me parler."
      }
    },
    {
      'auth': {'email': "juliette@gmail.com", 'password': "azerty"},
      'photo': {
        'fileName': "juliette.jpg",
      },
      'profile': {
        'name': "Juliette",
        'location': GeoPoint(45.777962, 4.870118),
        'gender': "f",
        'interestedIn': "m",
        'birthdate': DateTime.utc(1998, 08, 16),
        'maxDistance': 30,
        'minAge': 20,
        'maxAge': 26,
        'bio':
            "À la recherche de quelqu’un pour pleurer avec moi devant les films romantiques."
      }
    },
    {
      'auth': {'email': "laura@gmail.com", 'password': "azerty"},
      'photo': {
        'fileName': "laura.jpg",
      },
      'profile': {
        'name': "Laura",
        'location': GeoPoint(45.773557, 4.866961),
        'gender': "f",
        'interestedIn': "m",
        'birthdate': DateTime.utc(1997, 04, 25),
        'maxDistance': 30,
        'minAge': 21,
        'maxAge': 27,
        'bio':
            "Préfère les longues conversations plutôt que les rencontres superficielles."
      }
    },
    {
      'auth': {'email': "manon@gmail.com", 'password': "azerty"},
      'photo': {
        'fileName': "manon.jpg",
      },
      'profile': {
        'name': "Manon",
        'location': GeoPoint(45.773004, 4.872391),
        'gender': "f",
        'interestedIn': "m",
        'birthdate': DateTime.utc(1997, 09, 14),
        'maxDistance': 30,
        'minAge': 21,
        'maxAge': 27,
        'bio':
            "J’hésite entre une blague pour montrer que j’ai de l’humour ou une citation pour montrer que j’ai de l’esprit."
      }
    },
    {
      'auth': {'email': "martin@gmail.com", 'password': "azerty"},
      'photo': {
        'fileName': "martin.jpg",
      },
      'profile': {
        'name': "Martin",
        'location': GeoPoint(45.774635, 4.876275),
        'gender': "m",
        'interestedIn': "f",
        'birthdate': DateTime.utc(1997, 02, 21),
        'maxDistance': 30,
        'minAge': 20,
        'maxAge': 27,
        'bio':
            "On dira à tes parents qu’on s’est rencontrés dans une bibliothèque."
      }
    },
    {
      'auth': {'email': "olivia@gmail.com", 'password': "azerty"},
      'photo': {
        'fileName': "olivia.jpg",
      },
      'profile': {
        'name': "Olivia",
        'location': GeoPoint(45.770063, 4.865718),
        'gender': "f",
        'interestedIn': "m",
        'birthdate': DateTime.utc(1998, 04, 17),
        'maxDistance': 30,
        'minAge': 20,
        'maxAge': 25,
        'bio': "Plus jolie, plus sympa et plus fun que ton ex petite amie."
      }
    },
    {
      'auth': {'email': "romain@gmail.com", 'password': "azerty"},
      'photo': {
        'fileName': "romain.jpg",
      },
      'profile': {
        'name': "Romain",
        'location': GeoPoint(45.778077, 4.863875),
        'gender': "m",
        'interestedIn': "f",
        'birthdate': DateTime.utc(1996, 10, 03),
        'maxDistance': 30,
        'minAge': 20,
        'maxAge': 27,
        'bio':
            "Si tu aimes le sport extrême et que tu as un chat, alors je t’aime déjà."
      }
    },
    {
      'auth': {'email': "sofia@gmail.com", 'password': "azerty"},
      'photo': {
        'fileName': "sofia.jpg",
      },
      'profile': {
        'name': "Sofia",
        'location': GeoPoint(45.780624, 4.881586),
        'gender': "f",
        'interestedIn': "m",
        'birthdate': DateTime.utc(1996, 12, 15),
        'maxDistance': 30,
        'minAge': 22,
        'maxAge': 27,
        'bio':
            "Je connais un des numéros du prochain tirage de l’euro-million. Qui connait les 6 autres ?"
      }
    },
    {
      'auth': {'email': "thomas@gmail.com", 'password': "azerty"},
      'photo': {
        'fileName': "thomas.jpg",
      },
      'profile': {
        'name': "Thomas",
        'location': GeoPoint(45.773910, 4.874167),
        'gender': "m",
        'interestedIn': "f",
        'birthdate': DateTime.utc(1997, 07, 12),
        'maxDistance': 30,
        'minAge': 20,
        'maxAge': 25,
        'bio':
            "Est-ce que tu as décidé de passer ta vie avec des losers comme ton ex ou plutôt de changer le monde avec moi ?"
      }
    },
  ];

  List<Map<String, String>> mcq = [
    {
      "question": "Qu’est-ce qui t'irrite le plus ?",
      "correct_answer": "Qu'on t'ignore.",
      "option_2": "Qu'on ne te remercie pas.",
      "option_3": "Qu'on t'impose quelque chose.",
    },
    {
      "question": "Tu es sur une île déserte, tu cherches avant tout :",
      "correct_answer": "Une tribu autochtone, ils ont à manger et à boire.",
      "option_2": "Un abri, de préférence une grotte.",
      "option_3": "À te faire remarquer en allumant un feu.",
    },
    {
      "question": "Si on te sort une blague pourrie :",
      "correct_answer": "Tu te marres quand même.",
      "option_2": "Tu fais comprendre à l’autre que sa blague est naze.",
      "option_3":
          "Tu ries jaune, histoire de ne pas mettre l’autre mal à l’aise.",
    },
    {
      "question": "Pour t'éclater en soirée ?",
      "correct_answer": "Boîte de nuit",
      "option_2": "Karaoké",
      "option_3": "Restaurant",
    },
    {
      "question": "Le compliment qui te fait craquer :",
      "correct_answer": "Tu as toujours raison.",
      "option_2": "Tu es incroyable !",
      "option_3": "Je suis si bien avec toi.",
    },
    {
      "question": "Ta technique de séduction :",
      "correct_answer": "Tu le/la fais rire.",
      "option_2": "Tu l’écoutes.",
      "option_3": "Tu l’envoûtes.",
    }
  ];

  Future<File> convertImageToFile(ByteData data, String fileName) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/' + fileName;
    return new File(filePath).writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> addUsers([bool delete = false]) async {
    print("Seed users en cours...");
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

    //Supprime les données d'un document mais pas ses collections
    if (delete) {
      await _firebaseFirestore.collection('users').get().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    }

    String userId;
    for (var user in usersList) {
      try {
        await _firebaseAuth.createUserWithEmailAndPassword(
            email: user['auth']['email'], password: user['auth']['password']);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          await _firebaseAuth.signInWithEmailAndPassword(
              email: user['auth']['email'], password: user['auth']['password']);
        }
      } catch (e) {
        print(e);
      }

      _firebaseAuth.authStateChanges();
      userId = _firebaseAuth.currentUser.uid;

      user['profile'].putIfAbsent('uid', () => userId);
      user['profile'].putIfAbsent('mcq', () => mcq);

      var data = await rootBundle
          .load('assets/user_photos/' + user['photo']['fileName']);
      File userPhoto =
          await convertImageToFile(data, user['photo']['fileName']);
      StorageUploadTask storageUploadTask = FirebaseStorage.instance
          .ref()
          .child('user_photos')
          .child(userId)
          .child(userId)
          .putFile(userPhoto);

      await storageUploadTask.onComplete.then((ref) async {
        await ref.ref.getDownloadURL().then((url) async {
          user['profile'].putIfAbsent('photoUrl', () => url);
          await _firebaseFirestore
              .collection('users')
              .doc(userId)
              .set(user['profile']);
        });
      });
    }

    print("Seed users OK");
  }
}
