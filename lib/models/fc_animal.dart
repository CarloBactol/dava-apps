// class FcAnimal {
//   FcAnimal({required this.animals});

//   factory FcAnimal.fromMap(Map<String, dynamic> map) => FcAnimal(
//         animals:
//             List<Animals>.from(map['animals'].map((e) => Animals.fromMap(e))),
//       );

//   List<Animals> animals;

//   Map<String, dynamic> toMap() => {
//         'animals': animals.map((e) => e.toMap()).toList(),
//       };
// }

class Animals {
  Animals({
    required this.id,
    required this.species,
    required this.breed,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.color,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    required this.medicalRecords,
    required this.owner,
  });

  factory Animals.fromMap(Map<String, dynamic> map) => Animals(
        id: map['id'],
        species: map['species'],
        breed: map['breed'],
        name: map['name'],
        dateOfBirth: map['date_of_birth'],
        gender: map['gender'],
        color: map['color'],
        ownerId: map['owner_id'],
        createdAt: map['created_at'],
        updatedAt: map['updated_at'],
        medicalRecords: List<MedicalRecords>.from(
            map['medical_records'].map((e) => MedicalRecords.fromMap(e))),
        owner: Owner.fromMap(map['owner']),
      );

  int id;
  String species;
  String breed;
  String name;
  String dateOfBirth;
  String gender;
  String color;
  int ownerId;
  String createdAt;
  String updatedAt;
  List<MedicalRecords> medicalRecords;
  Owner owner;

  Map<String, dynamic> toMap() => {
        'id': id,
        'species': species,
        'breed': breed,
        'name': name,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'color': color,
        'owner_id': ownerId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'medical_records': medicalRecords.map((e) => e.toMap()).toList(),
        'owner': owner.toMap(),
      };
}

class Owner {
  Owner({required this.id, required this.ownerEmail});

  factory Owner.fromMap(Map<String, dynamic> map) => Owner(
        id: map['id'],
        ownerEmail: map['owner_email'],
      );

  int id;
  String ownerEmail;

  Map<String, dynamic> toMap() => {
        'id': id,
        'owner_email': ownerEmail,
      };
}

class MedicalRecords {
  MedicalRecords({
    required this.id,
    required this.vetId,
    required this.animalId,
    required this.procedure,
    required this.typeOfProcedure,
    required this.cost,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.veterinarian,
  });

  factory MedicalRecords.fromMap(Map<String, dynamic> map) => MedicalRecords(
        id: map['id'],
        vetId: map['vet_id'],
        animalId: map['animal_id'],
        procedure: map['procedure'],
        typeOfProcedure: map['type_of_procedure'],
        cost: map['cost'],
        notes: map['notes'] ?? '',
        createdAt: map['created_at'],
        updatedAt: map['updated_at'],
        veterinarian: Veterinarian.fromMap(map['veterinarian']),
      );

  int id;
  int vetId;
  int animalId;
  String procedure;
  String typeOfProcedure;
  String cost;
  String notes;
  String createdAt;
  String updatedAt;
  Veterinarian veterinarian;

  Map<String, dynamic> toMap() => {
        'id': id,
        'vet_id': vetId,
        'animal_id': animalId,
        'procedure': procedure,
        'type_of_procedure': typeOfProcedure,
        'cost': cost,
        'notes': notes,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'veterinarian': veterinarian.toMap(),
      };
}

class Veterinarian {
  Veterinarian({required this.id, required this.veterinarianEmail});

  factory Veterinarian.fromMap(Map<String, dynamic> map) => Veterinarian(
        id: map['id'],
        veterinarianEmail: map['veterinarian_email'],
      );

  int id;
  String veterinarianEmail;

  Map<String, dynamic> toMap() => {
        'id': id,
        'veterinarian_email': veterinarianEmail,
      };
}
