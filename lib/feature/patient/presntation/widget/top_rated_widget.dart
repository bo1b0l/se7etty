import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:se7ety/core/widgets/doctor_card.dart';
import 'package:se7ety/feature/auth/data/model/doctor_model.dart';

// Collection ?
//1) docId?
//2) list of documents
// a) orderBy  
// b) where 
// c) startAt and endAt 

class TopRatedList extends StatefulWidget {
  const TopRatedList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TopRatedListState createState() => _TopRatedListState();
}

class _TopRatedListState extends State<TopRatedList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('doctors')
            .orderBy('rating', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                value: .9,
                color: Colors.black12,
              ),
            );
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DoctorModel doctor = DoctorModel.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>,
                );
                if (doctor.specialization == '') {
                  return const SizedBox();
                }
                return DoctorCard(
                  doctor: doctor,
                );
              },
            );
          }
        },
      ),
    );
  }
}
