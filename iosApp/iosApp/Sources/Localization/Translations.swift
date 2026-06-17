import Foundation

/// Static translation tables. Keys are either `LKey.rawValue` (UI strings) or
/// dotted content keys ("team.BRA", "legend.pele.bio", …).
enum Translations {

    static let tables: [Language: [String: String]] = [
        .english: english,
        .portuguese: portuguese
    ]

    // MARK: - English

    static let english: [String: String] = [
        // General
        "appName": "Football Better Sport",
        "headerSubtitle": "Copa 2026 · Matchday %d",
        "done": "Done",
        "settings": "Settings",
        "language": "Language",
        "about": "About",
        "version": "Version",
        "aboutBlurb": "An unofficial fan companion for the most decorated nation in world football. Five stars and counting.",
        "generalSection": "General",
        "contentSection": "Content",
        "languageHint": "Tap a flag to switch instantly",

        // Tabs
        "tabHub": "Hub", "tabGroup": "Group", "tabSquad": "Squad",
        "tabHistory": "History", "tabCabinet": "Cabinet",

        // Hub
        "predictEarn": "Predict & Earn",
        "starMen": "Star Men",
        "featured": "Featured · Group D",
        "kickOff": "Kick-Off", "resume": "Resume", "pause": "Pause",
        "playAgain": "Play Again", "tapKickOff": "Tap Kick-Off", "paused": "Paused",
        "fullTime": "Full Time", "live": "LIVE", "draw": "Draw", "vs": "vs",
        "nextFixtures": "Next Fixtures",

        // Table
        "groupDTitle": "Group D", "topTwoAdvance": "Top 2 advance",
        "colTeam": "Team", "colForm": "Form", "resultsFixtures": "Results & Fixtures",
        "group": "Group", "matchdayShort": "MD", "fullTimeShort": "FT",

        // Squad
        "filterAll": "All", "filterFavourites": "Favourites",
        "noFavourites": "No favourites yet.\nTap the ★ on a player to add them here.",
        "attributes": "Attributes", "season": "Season",
        "statGoals": "Goals", "statAssists": "Assists", "statCaps": "Caps",
        "ovr": "OVR", "squadTitle": "Squad",

        // History
        "historyTitle": "A Seleção",
        "historyBlurb": "From the heartbreak of the Maracanazo to five World Cups and the jogo bonito, no nation has shaped the game like Brazil.",
        "timelineTitle": "Timeline",
        "legendsTitle": "Hall of Fame",
        "legendsSub": "The greats who wore the canary yellow",
        "honoursTitle": "Honours",
        "eraLabel": "Era", "currentStarsTitle": "Today's Stars",
        "capsLabel": "Caps", "goalsLabel": "Goals",

        // Cabinet
        "trophyCabinet": "Trophy Cabinet", "proShop": "Pro Shop",
        "addToBag": "Add to Bag", "addedToBag": "Added to Bag",
        "inBag": "In Bag", "bag": "Bag",
        "rankUpHint": "Predict matches & favourite players to rank up",
        "fanPoints": "%d fan points",

        // Events
        "evKickoff": "Kick-off at the Maracanã!",
        "evGoal": "GOAL! %@ find the net! %d–%d",
        "evChance": "%@ go close — just wide!",
        "evSave": "Brilliant save denies %@!",
        "evYellow": "Yellow card on a %@ challenge.",
        "evHalftime": "Half-time. %d–%d.",
        "evFulltime": "Full Time · %@ %d–%d %@",

        // Days
        "dayToday": "Today", "daySat": "Sat", "dayWed": "Wed",
        "dayThu": "Thu", "dayFri": "Fri",

        // Teams
        "team.BRA": "Brazil", "team.ARG": "Argentina", "team.FRA": "France",
        "team.ESP": "Spain", "team.POR": "Portugal", "team.ENG": "England",
        "team.GER": "Germany", "team.URU": "Uruguay", "team.CRO": "Croatia",
        "team.NED": "Netherlands",

        // Positions
        "posLong.GK": "Goalkeeper", "posLong.DEF": "Defender",
        "posLong.MID": "Midfielder", "posLong.FWD": "Forward",

        // Fan levels
        "level.0": "Rookie", "level.1": "Supporter", "level.2": "Member",
        "level.3": "Star", "level.4": "Legend",

        // Current player nicknames
        "nick.alisson": "The Wall", "nick.militao": "Tank", "nick.marquinhos": "Captain",
        "nick.beraldo": "The Rampart", "nick.bruno": "The Maestro", "nick.paqueta": "The Joker",
        "nick.rodrygo": "The Rocket", "nick.vini": "Vini Jr", "nick.endrick": "The Future",
        "nick.raphinha": "Pinga", "nick.casemiro": "The Anchor", "nick.danilo": "The Soldier",

        // Trophies
        "trophy.worldcup.title": "World Cup",
        "trophy.worldcup.sub": "1958 · 62 · 70 · 94 · 2002",
        "trophy.copaamerica.title": "Copa América",
        "trophy.copaamerica.sub": "Last lifted 2019",
        "trophy.confed.title": "Confed. Cup",
        "trophy.confed.sub": "Record holders",
        "trophy.copa2026.title": "Copa 2026",
        "trophy.copa2026.sub": "Group stage in progress",

        // Kit
        "kit.jersey.name": "2026 Home Jersey", "kit.jersey.detail": "Canarinho · Dri-FIT ADV",
        "kit.boot.name": "Phantom Boots", "kit.boot.detail": "Firm-ground · signature",
        "kit.whistle.name": "Match Whistle", "kit.whistle.detail": "Official referee edition",
        "kit.flag.name": "Supporter Flag", "kit.flag.detail": "Ordem e Progresso",

        // Legends — nicknames
        "legendNick.pele": "The King",
        "legendNick.garrincha": "Joy of the People",
        "legendNick.zico": "The White Pelé",
        "legendNick.socrates": "The Doctor",
        "legendNick.romario": "Baixinho",
        "legendNick.ronaldo": "Il Fenomeno",
        "legendNick.ronaldinho": "The Wizard",
        "legendNick.robertocarlos": "The Bullet",
        "legendNick.cafu": "The Express Train",

        // Legends — bios
        "legend.pele.bio": "The only man to win three World Cups, Pelé scored over a thousand career goals and turned football into art.",
        "legend.garrincha.bio": "With bent legs and impossible dribbles, Garrincha bewitched defenders and never lost a match for Brazil with Pelé alongside him.",
        "legend.zico.bio": "The finest playmaker of his era, Zico orchestrated the beloved 1982 side and remains a free-kick master.",
        "legend.socrates.bio": "Captain, doctor and democrat, Sócrates led with backheels and brains for the romantic 1982 team.",
        "legend.romario.bio": "A penalty-box predator of pure instinct, Romário fired Brazil to the 1994 title and the toe-poke into legend.",
        "legend.ronaldo.bio": "The original Ronaldo redefined the striker — pace, power and the redemption of 2002's eight goals.",
        "legend.ronaldinho.bio": "All joy and elastico, Ronaldinho made defenders laugh and cry, winning a World Cup and two Ballons d'Or.",
        "legend.robertocarlos.bio": "The thunderbolt left-back whose impossible free-kick defied physics and whose runs broke every flank.",
        "legend.cafu.bio": "The most-capped Brazilian and the only player to start three straight World Cup finals.",

        // Legends — honours
        "legend.pele.honour": "3× World Cup",
        "legend.garrincha.honour": "2× World Cup",
        "legend.zico.honour": "Golden Ball '82",
        "legend.socrates.honour": "Captain '82",
        "legend.romario.honour": "WC '94 · Best Player",
        "legend.ronaldo.honour": "2× World Cup · 15 WC goals",
        "legend.ronaldinho.honour": "WC '02 · 2× Ballon d'Or",
        "legend.robertocarlos.honour": "WC '02 · 125 caps",
        "legend.cafu.honour": "2× World Cup · 142 caps",

        // History timeline
        "history.wc1950.title": "1950 · The Maracanazo",
        "history.wc1950.detail": "Brazil lose the final at a packed Maracanã to Uruguay — the wound that built a dynasty.",
        "history.wc1958.title": "1958 · First Star",
        "history.wc1958.detail": "A 17-year-old Pelé bursts onto the world stage in Sweden as Brazil win their first World Cup.",
        "history.wc1962.title": "1962 · Back to Back",
        "history.wc1962.detail": "Garrincha carries the team in Chile after Pelé's injury — champions again.",
        "history.wc1970.title": "1970 · The Greatest Team",
        "history.wc1970.detail": "Pelé, Jairzinho and Carlos Alberto produce the most beautiful football ever and keep the Jules Rimet trophy.",
        "history.sel1982.title": "1982 · Beautiful Losers",
        "history.sel1982.detail": "Zico, Sócrates and Falcão dazzle the world but fall to Italy — the most loved side never to win.",
        "history.wc1994.title": "1994 · The Tetra",
        "history.wc1994.detail": "Romário and Bebeto end a 24-year wait, winning on penalties in the USA.",
        "history.wc2002.title": "2002 · The Penta",
        "history.wc2002.detail": "Ronaldo, Rivaldo and Ronaldinho light up Asia for a record fifth title.",
        "history.mineirazo2014.title": "2014 · The Mineirazo",
        "history.mineirazo2014.detail": "A 7–1 semi-final loss to Germany at home — the darkest night, and a rebuilding.",
        "history.copa2019.title": "2019 · Copa América",
        "history.copa2019.detail": "Brazil lift the continental crown on home soil at the Maracanã.",
        "history.copa2026.title": "2026 · The Hunt for Six",
        "history.copa2026.detail": "A new golden generation chases the elusive sixth star.",
    ]

    // MARK: - Portuguese (Brazil)

    static let portuguese: [String: String] = [
        // General
        "appName": "Football Better Sport",
        "headerSubtitle": "Copa 2026 · Rodada %d",
        "done": "Concluído",
        "settings": "Ajustes",
        "language": "Idioma",
        "about": "Sobre",
        "version": "Versão",
        "aboutBlurb": "Um companheiro não-oficial do torcedor da nação mais vitoriosa do futebol mundial. Cinco estrelas e contando.",
        "generalSection": "Geral",
        "contentSection": "Conteúdo",
        "languageHint": "Toque numa bandeira para trocar na hora",

        // Tabs
        "tabHub": "Início", "tabGroup": "Grupo", "tabSquad": "Elenco",
        "tabHistory": "História", "tabCabinet": "Galeria",

        // Hub
        "predictEarn": "Palpite & Ganhe",
        "starMen": "Craques",
        "featured": "Destaque · Grupo D",
        "kickOff": "Pontapé", "resume": "Retomar", "pause": "Pausar",
        "playAgain": "Jogar de Novo", "tapKickOff": "Toque para Iniciar", "paused": "Pausado",
        "fullTime": "Fim de Jogo", "live": "AO VIVO", "draw": "Empate", "vs": "x",
        "nextFixtures": "Próximos Jogos",

        // Table
        "groupDTitle": "Grupo D", "topTwoAdvance": "2 avançam",
        "colTeam": "Time", "colForm": "Forma", "resultsFixtures": "Resultados & Jogos",
        "group": "Grupo", "matchdayShort": "RD", "fullTimeShort": "FIM",

        // Squad
        "filterAll": "Todos", "filterFavourites": "Favoritos",
        "noFavourites": "Nenhum favorito ainda.\nToque na ★ de um jogador para adicioná-lo aqui.",
        "attributes": "Atributos", "season": "Temporada",
        "statGoals": "Gols", "statAssists": "Assist.", "statCaps": "Jogos",
        "ovr": "GER", "squadTitle": "Elenco",

        // History
        "historyTitle": "A Seleção",
        "historyBlurb": "Do trauma do Maracanazo aos cinco títulos mundiais e ao jogo bonito, nenhuma nação moldou o futebol como o Brasil.",
        "timelineTitle": "Linha do Tempo",
        "legendsTitle": "Galeria dos Imortais",
        "legendsSub": "Os gênios que vestiram a amarelinha",
        "honoursTitle": "Conquistas",
        "eraLabel": "Era", "currentStarsTitle": "Craques de Hoje",
        "capsLabel": "Jogos", "goalsLabel": "Gols",

        // Cabinet
        "trophyCabinet": "Sala de Troféus", "proShop": "Loja Oficial",
        "addToBag": "Adicionar à Sacola", "addedToBag": "Adicionado",
        "inBag": "Na Sacola", "bag": "Sacola",
        "rankUpHint": "Dê palpites e favorite jogadores para subir de nível",
        "fanPoints": "%d pontos de torcedor",

        // Events
        "evKickoff": "Bola rolando no Maracanã!",
        "evGoal": "GOL! %@ balança a rede! %d–%d",
        "evChance": "%@ assusta — por pouco!",
        "evSave": "Que defesa! Pegou de %@!",
        "evYellow": "Cartão amarelo em falta de %@.",
        "evHalftime": "Intervalo. %d–%d.",
        "evFulltime": "Fim de jogo · %@ %d–%d %@",

        // Days
        "dayToday": "Hoje", "daySat": "Sáb", "dayWed": "Qua",
        "dayThu": "Qui", "dayFri": "Sex",

        // Teams
        "team.BRA": "Brasil", "team.ARG": "Argentina", "team.FRA": "França",
        "team.ESP": "Espanha", "team.POR": "Portugal", "team.ENG": "Inglaterra",
        "team.GER": "Alemanha", "team.URU": "Uruguai", "team.CRO": "Croácia",
        "team.NED": "Holanda",

        // Positions
        "posLong.GK": "Goleiro", "posLong.DEF": "Zagueiro",
        "posLong.MID": "Meia", "posLong.FWD": "Atacante",

        // Fan levels
        "level.0": "Novato", "level.1": "Torcedor", "level.2": "Sócio",
        "level.3": "Craque", "level.4": "Lenda",

        // Current player nicknames
        "nick.alisson": "O Muro", "nick.militao": "Tanque", "nick.marquinhos": "Capitão",
        "nick.beraldo": "A Muralha", "nick.bruno": "O Maestro", "nick.paqueta": "O Coringa",
        "nick.rodrygo": "Foguete", "nick.vini": "Vini Jr", "nick.endrick": "O Futuro",
        "nick.raphinha": "Pinga", "nick.casemiro": "O Cabeça de Área", "nick.danilo": "O Soldado",

        // Trophies
        "trophy.worldcup.title": "Copa do Mundo",
        "trophy.worldcup.sub": "1958 · 62 · 70 · 94 · 2002",
        "trophy.copaamerica.title": "Copa América",
        "trophy.copaamerica.sub": "Última em 2019",
        "trophy.confed.title": "Copa das Confed.",
        "trophy.confed.sub": "Maiores campeões",
        "trophy.copa2026.title": "Copa 2026",
        "trophy.copa2026.sub": "Fase de grupos em andamento",

        // Kit
        "kit.jersey.name": "Camisa I 2026", "kit.jersey.detail": "Canarinho · Dri-FIT ADV",
        "kit.boot.name": "Chuteira Phantom", "kit.boot.detail": "Campo firme · edição",
        "kit.whistle.name": "Apito Oficial", "kit.whistle.detail": "Edição de arbitragem",
        "kit.flag.name": "Bandeira do Torcedor", "kit.flag.detail": "Ordem e Progresso",

        // Legends — nicknames
        "legendNick.pele": "O Rei",
        "legendNick.garrincha": "Alegria do Povo",
        "legendNick.zico": "Galinho de Quintino",
        "legendNick.socrates": "O Doutor",
        "legendNick.romario": "Baixinho",
        "legendNick.ronaldo": "O Fenômeno",
        "legendNick.ronaldinho": "O Bruxo",
        "legendNick.robertocarlos": "O Homem-Bala",
        "legendNick.cafu": "O Pendolino",

        // Legends — bios
        "legend.pele.bio": "Único tricampeão mundial, Pelé marcou mais de mil gols na carreira e transformou o futebol em arte.",
        "legend.garrincha.bio": "Com as pernas tortas e dribles impossíveis, Garrincha encantou marcadores e nunca perdeu jogando ao lado de Pelé.",
        "legend.zico.bio": "O maior armador de sua era, Zico comandou a amada seleção de 1982 e é mestre das faltas.",
        "legend.socrates.bio": "Capitão, médico e democrata, Sócrates liderou com calcanhares e inteligência o romântico time de 82.",
        "legend.romario.bio": "Predador da área de puro instinto, Romário levou o Brasil ao Tetra de 1994 e eternizou o toquinho.",
        "legend.ronaldo.bio": "O Fenômeno redefiniu o centroavante — velocidade, força e a redenção dos oito gols de 2002.",
        "legend.ronaldinho.bio": "Pura alegria e elástico, Ronaldinho fez zagueiros rirem e chorarem, com um Mundial e duas Bolas de Ouro.",
        "legend.robertocarlos.bio": "O lateral-canhão cuja falta impossível desafiou a física e cujas subidas quebravam qualquer lado.",
        "legend.cafu.bio": "O brasileiro com mais jogos e o único a disputar três finais de Copa seguidas como titular.",

        // Legends — honours
        "legend.pele.honour": "3× Copa do Mundo",
        "legend.garrincha.honour": "2× Copa do Mundo",
        "legend.zico.honour": "Bola de Ouro '82",
        "legend.socrates.honour": "Capitão '82",
        "legend.romario.honour": "Copa '94 · Melhor Jogador",
        "legend.ronaldo.honour": "2× Mundial · 15 gols em Copas",
        "legend.ronaldinho.honour": "Copa '02 · 2× Bola de Ouro",
        "legend.robertocarlos.honour": "Copa '02 · 125 jogos",
        "legend.cafu.honour": "2× Mundial · 142 jogos",

        // History timeline
        "history.wc1950.title": "1950 · O Maracanazo",
        "history.wc1950.detail": "O Brasil perde a final num Maracanã lotado para o Uruguai — a ferida que construiu uma dinastia.",
        "history.wc1958.title": "1958 · A Primeira Estrela",
        "history.wc1958.detail": "Aos 17 anos, Pelé surge para o mundo na Suécia e o Brasil conquista sua primeira Copa.",
        "history.wc1962.title": "1962 · O Bi",
        "history.wc1962.detail": "Garrincha carrega o time no Chile após a lesão de Pelé — campeões de novo.",
        "history.wc1970.title": "1970 · O Melhor Time",
        "history.wc1970.detail": "Pelé, Jairzinho e Carlos Alberto fazem o futebol mais bonito de todos e ficam com a taça Jules Rimet.",
        "history.sel1982.title": "1982 · Os Belos Perdedores",
        "history.sel1982.detail": "Zico, Sócrates e Falcão encantam o mundo mas caem para a Itália — o time mais amado sem título.",
        "history.wc1994.title": "1994 · O Tetra",
        "history.wc1994.detail": "Romário e Bebeto encerram um jejum de 24 anos, vencendo nos pênaltis nos EUA.",
        "history.wc2002.title": "2002 · O Penta",
        "history.wc2002.detail": "Ronaldo, Rivaldo e Ronaldinho brilham na Ásia pelo quinto título recorde.",
        "history.mineirazo2014.title": "2014 · O Mineirazo",
        "history.mineirazo2014.detail": "Um 7 a 1 da Alemanha em casa na semifinal — a noite mais escura, e uma reconstrução.",
        "history.copa2019.title": "2019 · Copa América",
        "history.copa2019.detail": "O Brasil levanta a taça continental em casa, no Maracanã.",
        "history.copa2026.title": "2026 · A Caça ao Hexa",
        "history.copa2026.detail": "Uma nova geração de ouro persegue a sexta estrela.",
    ]
}
