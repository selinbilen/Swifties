import SwiftUI
import Firebase

var database = Firestore.firestore()

struct Room: Identifiable {
    let id = UUID() // id for every room instance
    let participants: [String]
    let startTime: Date? = nil // date-time the game started
    let participantGameplays: [ParticipantGameplay] // list of gameplays
}

struct Participant: Identifiable {
    let id = UUID()
    var nickname: String
}

struct ParticipantGameplay: Identifiable {
    let id = UUID() // id for every ParticipantGameplay instance
    let participantId: String // id of Participant
    var checkpointTime: Date // date-time the player found an object
    var score: Int = 0 // numerical score
}

// Helpful video for working with date objects https://www.youtube.com/watch?v=Le8VmQyZWYw

struct LeaderboardView: View {
    @Binding var RoomObj: Room

    var body: some View {
        VStack {
            Text("Leaderboard for Room \(RoomObj.id.uuidString)")
        }
        .navigationTitle("Leaderboard View")
    }
}

let exampleParticipantGameplays = [
    ParticipantGameplay(participantId: "1001", checkpointTime: Date().addingTimeInterval(42)),
    ParticipantGameplay(participantId: "1002", checkpointTime: Date().addingTimeInterval(131)),
    ParticipantGameplay(participantId: "1003", checkpointTime: Date().addingTimeInterval(34)),
    ParticipantGameplay(participantId: "1004", checkpointTime: Date().addingTimeInterval(256)),
]

struct HostView: View {
    @State var room = Room(participants: [], participantGameplays: [])
    @Binding var participant: Participant
    
    var body: some View {
        VStack {
            Text("Host View")
            Text("Room ID: \(room.id.uuidString)")
        }
        .navigationTitle("Host")
        .onAppear {
            let docRef = database.collection("rooms")
            docRef.document(room.id.uuidString).setData(["participants": room.participants])
        }
    }
}

struct JoinView: View {
    var body: some View {
        VStack {
            Text("Join View")
        }
        .navigationTitle("Join")
    }
}

struct ContentView: View {
    @State var participant = Participant(nickname: "Nickname")
    
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            database = Firestore.firestore()
        }
    }
    
    func updateParticipant() {
        let docRef = database.collection("participants")
        docRef.document(participant.id.uuidString).setData(["nickname": participant.nickname])
    }
    
    var body: some View {
        NavigationView(content: {
            VStack {
                Text("Quiz Game")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                TextField("Nickname", text: $participant.nickname)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 20)
                    .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                    .cornerRadius(5)
                    .font(.title2)
                    .onChange(of: participant.nickname, perform: { value in
                        updateParticipant()
                    })
                
                Spacer()
                
                NavigationLink(destination: HostView(participant: $participant)) {
                    Text("Host")
                    .font(.title3)
                }
                
                NavigationLink(destination: JoinView()) {
                    Text("Join")
                    .font(.title3)
                }
            }
            .padding(.horizontal, 30)
            .onAppear {
                updateParticipant()
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
