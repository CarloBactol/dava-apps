class Animal {
  final String name;
  final String species;
  final String breed;
  final String gender;
  final String color;
  final String dob;
  final Medicalrecord medicalrecords;
  final Owner owneremail;

  Animal({
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.color,
    required this.dob,
    required this.medicalrecords,
    required this.owneremail,
  });
}

class Medicalrecord {
  final String procedure;
  final String typeofprocedure;
  final String cost;
  final String notes;
  final String createdat;
  final Veterinarian veterinarian;
  Medicalrecord({
    required this.procedure,
    required this.typeofprocedure,
    required this.cost,
    required this.notes,
    required this.createdat,
    required this.veterinarian,
  });
}

class Veterinarian {
  final String veterinarianemail;
  Veterinarian({
    required this.veterinarianemail,
  });
}

class Owner {
  final String owneremail;
  Owner({
    required this.owneremail,
  });
}
