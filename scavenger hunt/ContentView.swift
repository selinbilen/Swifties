import SwiftUI
import Firebase

var database = Firestore.firestore()

struct Question {
    var prompt: String?
    var options: [String]
}

let questions = [
    Question(prompt: "Prompt 1", options: ["Option A", "Option B", "Option C", "Option D"]),
    Question(prompt: "Prompt 2", options: ["Option A", "Option B", "Option C", "Option D"]),
    Question(prompt: "Prompt 3", options: ["Option A", "Option B", "Option C", "Option D"]),
    Question(prompt: "Prompt 3", options: ["Option A", "Option B", "Option C", "Option D"])
]

struct Room: Identifiable {
    var id = UUID().uuidString // id for every room instance
    var nickname: String // name of room
    var participants: [String] // array of participant uuids
    var startTime: Timestamp? = nil // date-time the game started
    var gameplays: [String] = []
    var maxRound: Int = 5
    var gameplayIndex: Int = 0
}

struct Participant: Identifiable {
    let id = UUID()
    var nickname: String
    var roomId: String = ""
    var isHost: Bool = false
}

struct LeaderboardView: View {
    @Binding var room: Room
    @Binding var participant: Participant
    
    var body: some View {
        VStack {
            Text("Leaderboard for Room \(room.id)")
        }
        .navigationTitle("Leaderboard View")
    }
}

struct GameView: View {
    @Binding var room: Room
    @Binding var participant: Participant
    
    struct Gameplay {
        var id: String
        var participants: [String]
        var timestamps: [Timestamp]
    }
    
    @State var currGameplay = Gameplay(id: "", participants: [], timestamps: [])
    
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
                
                room.gameplays = data["gameplays"] as! [String]
                room.gameplayIndex = data["gameplayIndex"] as! Int
                currGameplay.id = room.gameplays[room.gameplayIndex]
            }
    }
    
    func streamGameplay() {
        database.collection("gameplays").document(room.gameplays[room.gameplayIndex])
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                
                currGameplay.participants = data["participants"] as! [String]
                currGameplay.timestamps = data["timestamps"] as! [Timestamp]
            }
    }
    
    func updateGameplay() {
        let docRef = database.collection("gameplays")
        docRef.document(currGameplay.id).updateData(["participants": FieldValue.arrayUnion([participant.id.uuidString]), "timestamps": FieldValue.arrayUnion([Date()])])
    }
    
    func incrementGameplayIndex() {
        let docRef = database.collection("rooms")
        docRef.document(room.id).updateData(["gameplayIndex": room.gameplayIndex+1])
    }
    
    func hasResponded(participantId: String) -> Bool {
        return currGameplay.participants.contains(participantId)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    
                    Button(action: {
                        updateGameplay()
                    }, label: {
                        Text("Checkpoint!")
                            .foregroundColor(.white)
                    }).disabled(currGameplay.participants.contains(participant.id.uuidString))
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.red)
                    
                    Button(action: {
                        updateGameplay()
                    }, label: {
                        Text("Checkpoint!")
                            .foregroundColor(.white)
                    }).disabled(currGameplay.participants.contains(participant.id.uuidString))
                }
            }
            .padding(10)
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.green)
                    
                    Button(action: {
                        updateGameplay()
                    }, label: {
                        Text("Checkpoint!")
                            .foregroundColor(.white)
                    }).disabled(currGameplay.participants.contains(participant.id.uuidString))
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.yellow)
                    
                    Button(action: {
                        updateGameplay()
                    }, label: {
                        Text("Checkpoint!")
                            .foregroundColor(.white)
                    }).disabled(currGameplay.participants.contains(participant.id.uuidString))
                }
            }
            .padding(10)
            
            Spacer()
            
            HStack {
                ForEach(room.participants, id: \.self) {
                    participantId in AvatarGameplayView(participantId: participantId, hasResponded: hasResponded(participantId: participantId))
                }
            }
            
            NavigationLink(destination: LeaderboardView(room: $room, participant: $participant), isActive: .constant(room.gameplayIndex == 3)) {
                EmptyView()
            }
        }
        .navigationTitle("\(questions[room.gameplayIndex].prompt!)")
        .onAppear {
            streamRoom()
            streamGameplay()
        }
        .onChange(of: currGameplay.participants, perform: { value in
            if(currGameplay.participants.count == room.participants.count) {
                incrementGameplayIndex()
            }
        })
    }
}

struct AvatarGameplayView: View {
    var participantId: String
    var hasResponded: Bool
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
            VStack {
                Circle()
                    .size(CGSize(width: 75.0, height: 75.0))
                    .frame(width: 75.0, height: 75.0)
                    .foregroundColor(Color(red: 0.98, green: 0.98, blue: 0.98))
                    .overlay(Circle().stroke(hasResponded ? Color.blue : Color(red: 0.98, green: 0.98, blue: 0.98), lineWidth: 3)).foregroundColor(nil)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("\(participant.nickname)")
                })
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
        }
        .padding(.horizontal, 30)
        .onAppear {
            streamParticipant()
        }
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
                
                if(data["startTime"] != nil) {
                    let startTime = (data["startTime"] as AnyObject).dateValue()
                    timeRemaining = Int(Date().distance(to: startTime))
                }
            }
    }
    
    func updateRoom() {
        let docRef = database.collection("rooms")
        docRef.document(room.id).updateData(["gameplays": room.gameplays, "startTime": room.startTime as Any])
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
                    room.startTime = Timestamp(date: Date().addingTimeInterval(4))
                    
                    for _ in 1...room.maxRound {
                        let gameplayId = UUID().uuidString
                        
                        let docRef = database.collection("gameplays")
                        docRef.document(gameplayId).setData(["participants": [], "timestamps": []])
                        room.gameplays.append(gameplayId)
                    }
                    
                    updateRoom()
                }, label: {
                    if(room.startTime == nil) {
                        Text("Begin Game")
                    }
                })
                .disabled(room.participants.count < 1)
            }
            
            if(room.startTime != nil && timeRemaining >= 0) {
                Button(action: {
                }, label: {
                    if(timeRemaining == 0) {
                        Text("Good Luck!")
                    } else {
                        Text("\(timeRemaining)")
                    }
                })
            }
            
            NavigationLink(destination: GameView(room: $room, participant: $participant), isActive: .constant(timeRemaining == 0)) {
                EmptyView()
            }
            
            if(timeRemaining < 0) {
                NavigationLink(
                    destination: GameView(room: $room, participant: $participant),
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
        docRef.document(room.id).setData(["nickname": room.nickname, "participants": room.participants, "gameplays": room.gameplays, "gameplayIndex": room.gameplayIndex, "maxRound": room.maxRound])
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
                room.gameplays = data["gameplays"] as! [String]
            }
    }
    
    func updateRoom() {        
        let docRef = database.collection("rooms")
        docRef.document(room.id).updateData(["participants": FieldValue.arrayUnion([participant.id.uuidString])])
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
