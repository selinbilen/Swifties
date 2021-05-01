import SwiftUI
import Firebase

var database = Firestore.firestore()

struct Room: Identifiable {
    var id = UUID().uuidString // id for every room instance
    var nickname: String // name of room
    var participants: [String] // array of participant uuids
    var startTime: Date? = nil // date-time the game started
}

struct Participant: Identifiable {
    let id = UUID()
    var nickname: String
    var roomId: String = ""
    var isHost: Bool = false
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
            Text("Leaderboard for Room \(RoomObj.id)")
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

struct GameView: View {
    var body: some View {
        VStack {
            
        }
        .navigationTitle("Game")
    }
}

struct AvatarView: View {
    var participantId: String
    @State var participant = Participant(nickname: "")
    
    func streamParticipant() {
        database.collection("participants").document(participantId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                participant.nickname = data["nickname"] as! String
            }
    }
    
    var body: some View {
        HStack {
            Circle()
                .size(CGSize(width: 75.0, height: 75.0))
                .frame(width: 75.0, height: 75.0)
                .foregroundColor(Color(red: 0.98, green: 0.98, blue: 0.98))
            
            VStack {
                HStack {
                    Text("\(participant.nickname)")
                        .frame(width: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                
                HStack {
                    Text("Participant ID: \(participantId)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 30)
        .onAppear {
            streamParticipant()
        }
    }
}

struct LobbyView: View {
    @Binding var room: Room
    @Binding var participant: Participant
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 1000
    
    func streamRoom() {
        database.collection("rooms").document(room.id)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                room.participants = data["participants"] as! [String]
                if(room.startTime != nil) {
                    timeRemaining = Int(Date().distance(to: room.startTime!))
                }
            }
    }
    
    func updateRoom() {
        let docRef = database.collection("rooms")
        docRef.document(room.id).setData(["nickname": room.nickname, "participants": room.participants, "startTime": room.startTime as Any])
    }
    
    func actionSheet() {
        let urlShare = "\(room.id)"
        
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            ForEach(room.participants, id: \.self) {
                participantId in AvatarView(participantId: participantId)
            }
            
            Spacer()
            
            Button(action: actionSheet) {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
            }
            
            Spacer()
            
            if(room.participants[0] == participant.id.uuidString) {
                Button(action: {
                    room.startTime = Date().addingTimeInterval(11)
                    
                    updateRoom()
                }, label: {
                    if(room.startTime == nil) {
                        Text("Begin Game")
                    }
                })
                .disabled(room.participants.count == 1)
            }
            
            if(room.startTime != nil && timeRemaining >= 0) {
                Button(action: {
                }, label: {
                    if(timeRemaining == 0) {
                        Text("Good Luck!")
                        
                        NavigationLink(destination: GameView(), isActive: .constant(timeRemaining == 0)) {
                            EmptyView()
                        }
                    } else {
                        Text("\(timeRemaining)")
                    }
                })
            }
            
            if(timeRemaining < 0) {
                NavigationLink(
                    destination: GameView(),
                    label: {
                        Text("Resume")
                    })
            }
        }
        .navigationTitle("\(room.nickname)'s Lobby")
        .onAppear {
            streamRoom()
        }
        .onReceive(timer) { time in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
    }
}

struct HostView: View {
    @State var room = Room(nickname: "Antarctica", participants: [])
    @Binding var participant: Participant
    
    func updateRoom() {
        let docRef = database.collection("rooms")
        docRef.document(room.id).setData(["nickname": room.nickname, "participants": room.participants])
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                TextField("Nickname", text: $room.nickname)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 20)
                    .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                    .cornerRadius(5)
                    .font(.title2)
                
                Spacer()
            }
            
            HStack {
                Text("Room ID: \(room.id)")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            Spacer()
            
            NavigationLink(destination: LobbyView(room: $room, participant: $participant)) {
                Text("Lobby")
                    .font(.title3)
            }
            .disabled(room.nickname == "")
        }
        .padding(.horizontal, 30)
        .navigationTitle("Host")
        .onAppear {
            if(!room.participants.contains(participant.id.uuidString)) {
                room.participants.append(participant.id.uuidString)
            }
            
            updateRoom()
        }
        .onChange(of: room.nickname, perform: { value in
            updateRoom()
        })
    }
}

struct JoinView: View {
    @Binding var participant: Participant
    @State var room = Room(id: "", nickname: "", participants: [])
    
    func streamRoom() {
        database.collection("rooms").document(room.id)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                room.nickname = data["nickname"] as! String
                room.participants = data["participants"] as! [String]
            }
    }
    
    func updateRoom() {
        if(!room.participants.contains(participant.id.uuidString)) {
            room.participants.append(participant.id.uuidString)
        }
        
        let docRef = database.collection("rooms")
        docRef.document(room.id).setData(["nickname": room.nickname, "participants": room.participants])
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                TextField("Room ID", text: $room.id)
                    .padding(.all, 20)
                    .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                    .cornerRadius(5)
                    .font(.title2)
                
                Spacer()
            }
            
            HStack {
                Text("Participant ID: \(participant.id.uuidString)")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            Spacer()
            
            Button(action: {
                updateRoom()
            }, label: {
                Text("Join Room")
            })
            .disabled(room.id == "")
            
            NavigationLink(destination: LobbyView(room: $room, participant: $participant), isActive: .constant(room.participants.contains(participant.id.uuidString))) {
                EmptyView()
            }
            
        }
        .padding(.horizontal, 30)
        .navigationTitle("Join")
        .onChange(of: room.id, perform: { value in
            streamRoom()
        })
    }
}

struct ContentView: View {
    @State var participant = Participant(nickname: "")
    
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
                Spacer()
                
                HStack {
                    TextField("Nickname", text: $participant.nickname)
                        .padding(.all, 20)
                        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                        .cornerRadius(5)
                        .font(.title2)
                    
                    Spacer()
                }
                
                HStack {
                    Text("Participant ID: \(participant.id.uuidString)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    NavigationLink(destination: HostView(participant: $participant)) {
                        Text("Host")
                            .font(.title3)
                    }
                    .disabled(participant.nickname == "")
                    
                    NavigationLink(destination: JoinView(participant: $participant)) {
                        Text("Join")
                            .font(.title3)
                    }
                    .disabled(participant.nickname == "")
                }
            }
            .padding(.horizontal, 30)
            .onAppear {
                updateParticipant()
            }
            .onChange(of: participant.nickname, perform: { value in
                updateParticipant()
            })
            .navigationTitle("Game ")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
