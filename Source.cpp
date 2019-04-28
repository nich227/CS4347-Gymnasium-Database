#include <iostream>
#include <fstream>
#include <string>
#include <random>
	using namespace std;

	int main() {
		string type[] = { "yoga,", "aerobics,","weightlifting," };
		string name[] = { "Alex", "Belle", "Chip", "Daisy", "Elizabeth", "Flynn", "Greg", "Harold", "Isabelle", "Junaid", "Kelsey", "Leslie", "Mike", "Nicholas", "Oliver", "Peter", "Robin", "Samuel", "Tyler", "Violet", "Wendy" };
		string tname[] = { "Pushpa Kumar","Jason Smith","Farokh Bastani","Nhut Nguyen","Simeon Ntafos","Si Zheng","Kang Zhang",
			"Sergey Bereg","John Cole","Andras Farago","Kevin Hamlen","Herman Harrison","Latifur Khan","Neeraj Mittal",
			"Ramaswamy Chandrasekaran","Jorge Cobb","Xiaohu Guo","Greg Ozbirn","Dan Moldovan","Klaus Truemper","Yuke Wang",
			"Michael Christiansen","Lawrence Chung","Gopal Gupta","Neeraj Gupta","Nancy Van Ness","Subbarayan Venkatesan","Wei Wu" };
		string lname[] = { "Sou","Chen","Beisert","Baker","Alverez",
			"Charles","Shields","Lee","Cole","Smith",
			"Jhnson","Williams","Brown","Jones","Garcia",
			"Miller","Davis","Rodriguez","Martinez","Hernandez",
			"Lopez","Gonzalez","Wilson","Anderson","Thomas",
			"Taylor","Moore","jackson","Martin","Lee",
			"Perez","Thompson","White","Harris","Sanchez",
			"Clark","Ramirez","Lewis","Lewis","Robinson",
			"Walker","Young","Allen","King","Wright",
			"Scott","Torres","Nguyen","Hill","Florez",
			"Green","Adams","Nelson","Hall","Rivera",
			"Campbell","Mitchel","Carter","Roberts","Gomez",
			"Phillips","Evans","Turner","Diaz","Parker",
			"Cruz","Edwards","Collins","Reyes","Stewart",
			"Morris","Morales","Murphy","Cook","Rogers",
			"Ortiz","Morgan","Cooper","Peterson","Bailey",
			"Reed","Kelly","Howard","Ramos","Kim",
			"Cox","Ward","Richardson","Watson","Brooks",
			"Chavez","Wood","james","Bennett","Gray",
			"Ruiz","Hughes","Price","Alverez","Castillo",
			"Sanders","Patel","Meyers","Long","Ross",
			"Foster","Jimenez","Powell","Jenkins","Perry",
			"Russell","Sullivan","Bell","Coleman","Butler",
			"Henderson","Barnes","Fisher","Vasquez","Simmonw",
			"Romero","Jordan","Patterson","Alexander","Hamilton",
			"Graham","Reynolds","Griffin","Wallace","Moreno",
			"West","Bryant","Hayes","Herrera","Gibson",
			"Ellis","Tran","Stevens","Murray","Ford",
			"Castro","Marshall","Owens","Harrison","Fernandez",
			"McDonalld","Woods","Washington","Kennedy","Wells",
			"Vargas","Henry","Chen","Freeman","Webb",
			"Tucker","Guzman","Burns","Crawford","Olsen",
			"Simpson","Porter","Hunter","Gordon","Mendez",
			"Silva","Shaw","Snyder","Mason","Dixon",
			"Munoz","Hunt","Hicks","Holmes","Palmer",
			"Wagner","Black","Robertson","Boyd","Rose",
			"Stone","Salazar","Fox","Warren","Mills",
			"Meyer","Rice","Schmidt","Garza","Daniels",
			"Ferguson","Nichols","Stephens","Soto","Weaver",
			"Baxter","Gates","Chase","Sosa","Sweeney",
			"Farrell","Wyatt","Dalton","Horn","Barron",
			"Phelps","Yu","Dickerson","Heath","Foley",
			"Watkins","Mathews","Bonilla","Benitez","Zavala",
			"Hensley","Glenn","Harrell","Rubio","Choi",
			"Huffman","Boyer","Garrison","Bond","Kane",
			"Hancock","Callahan","Dillon","Cline","Wiggins",
			"Grimes","Melton","ONeill","Savage","Ho",
			"Ryan","Gardner","Payne","Grant","Dunn","Kelley" };
		int number = 1;
		//make output file stream
		ofstream myfile;
		//name the file and create it
		myfile.open("database.csv");
		//this is the command to write to the file
		myfile << "Writing this to a file.\n";
		//make trainers and their certifications
		for (int i = 0; i < 28; i++) {
			myfile << ("TRAINER," + tname[i] + ",12345 Sesame Street Richardson Tx 75080,email@email.com,1234567890," + to_string(number) + "\n");
			myfile << ("TRAINER_Certification," + type[(number % 3)] + to_string(number) + "\n");
			number++;
		}
		//make members**
		int j = 0;
		int k = 0;
		for (int i = 0; i < 5000; i++) {
			myfile << ("MEMBER,12345 Sesame Street Richardson Tx 75080,email@email.com,1234567890," + name[j] + " " + lname[k] + "," + to_string(number) + "," + to_string(rand() % 28) + "\n");
			j++;
			if (j == 21) {
				j = 0;
				k++;
			}
			number++;
		}
		//make rooms and their types
		myfile << ("ROOM,20,1\n");
		myfile << ("ROOM_Ctype," + type[1] + "1\n");
		myfile << ("ROOM,20,2\n");
		myfile << ("ROOM_Ctype," + type[2] + "2\n");
		myfile << ("ROOM,20,3\n");
		myfile << ("ROOM_Ctype," + type[0] + "3\n");
		myfile << ("ROOM,20,4\n");
		myfile << ("ROOM_Ctype," + type[1] + "4\n");


		//CLASS and ATTENDS
		int day = 1;
		int month = 1;
		int time;
		int credits;
		for (int i = 0; i < 350; i++) {
			credits = (rand() % 5) + 3;
			for (int j = 0; j < 18; j++) {
				time = j / 4;
				//date 1
			if (month < 10)
				myfile << ("CLASS,2019-0" + to_string(month));
			else
				myfile << ("CLASS,2019-" + to_string(month));
			if (day < 10)
				myfile << ("-0" + to_string(day)+" ");
			else
				myfile << ("-" + to_string(day) + " ");
			if (time == 0)
				myfile << ("08:00:00,");
			else if (time == 1)
				myfile << ("10:00:00,");
			else if (time == 2)
				myfile << ("14:00:00,");
			else if (time == 3)
				myfile << ("16:00:00,");
			else if (time == 4)
				myfile << ("18:00:00,");
			//date 2
			if (month < 10)
				myfile << ("2019-0" + to_string(month));
			else
				myfile << ("2019-" + to_string(month));
			if (day < 10)
				myfile << ("-0" + to_string(day) + " ");
			else
				myfile << ("-" + to_string(day) + " ");
			if (time == 0)
				myfile << ("09:15:00,");
			else if (time == 1)
				myfile << ("11:15:00,");
			else if (time == 2)
				myfile << ("15:15:00,");
			else if (time == 3)
				myfile << ("17:15:00,");
			else if (time == 4)
				myfile << ("19:15:00,");
			//class number credits type dics. credits, trainer, room#
			myfile << (to_string(number)+"," + to_string(credits) + "," + type[j%3] + "," + to_string(credits-2) + ","+to_string((i*350+j)%28+1)+"," + to_string((i * 350 + j) % 4 + 1)+"\n");
			//attends
			number++;
			}
			if (day == 29) {
				month++;
				day = 1;
			}
			else
				day++;
		}

		//random v1 = rand() % 100;
		//end of database making
		myfile.close();
		return 0;
}