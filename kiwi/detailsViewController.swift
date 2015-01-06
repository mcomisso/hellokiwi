//
//  detailsViewController.swift
//  kiwi
//
//  Created by Matteo Comisso on 04/01/15.
//  Copyright (c) 2015 Blue-Mate. All rights reserved.
//

import Foundation

class detailsViewController: UIViewController {
    @IBOutlet weak var presentationImage: UIImageView!
    @IBOutlet weak var textView: UITextView!

    let dataSource = ["222":"H-FARM è una piattaforma nata con l’obiettivo di aiutare giovani imprenditori nel lancio di piccole imprese innovative nel settore internet e di supportare la trasformazione delle aziende italiane in un’ottica digitale. \n Il modello di accelerazione delle imprese dura in media 36 mesi, durante i quali H-FARM investe e supporta il percorso di crescita di queste realtà. \nH-FARM ha sede nella tenuta agricola di Ca’ Tron (a 10 minuti da Venezia), Seattle (USA), Mumbai (India) e Londra (UK). Nei primi 9 anni, H-FARM ha investito circa € 18.2 milioni in 64 startup, creando oltre 390 nuovi posti di lavoro. \nIl fatturato aggregato delle aziende supera i 30 milioni di euro. \nTra il 2014-2018 sono previsti investimenti per ulteriori 10 milioni di euro.",

        "111":"LIFE è un’agenzia specializzata nell’interazione e nell’innovazione digitale.\n La nostra offerta si basa su 3 azioni principali: \n1. Design (Experience Design, Interaction Design, Service Design); \n\n2. Strategy (Digital Strategy, Social Business Strategy, Innovation Management); \n\n3. Tech (Digital Platforms, Web & Mobile Apps, Enterprise Platforms). \n\nLIFE vuole creare servizi ed esperienze di brand capaci di migliorare la vita del consumatore e ampliare le performance di business dell’azienda. \nStiamo lavorando con brand italiani e internazionali come Autogrill, Bottega Veneta, Diesel, Ernst & Young, Generali, RCS Media Group, Vodafone e con startup innovative come Henable, XYZE, Pathflow, Love the Sign.",

        "333":"KIWI: L\'esperienza d\'acquisto interattiva a portata di smartphone. \n\nIl progetto Kiwi, regala al cliente del mondo retail un'esperienza d'acquisto nuova e coinvolgente all'interno dello store. \nGrazie all'utilizzo dei beacons, disposti all'interno del punto vendita, il consumatore potrà vivere un'esperienza interattiva e personalizzata capace di veicolare con contenuti digitali la storia del prodotto, esaltando italianità-artiginalità e unicità, il tutto con un forte coinvolgimento emotivo."]
    
    var tabID: String = ""
    var imageName: String = ""
    var titleName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.loadData()
        
    }

    func setupViews() {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.tabBarController?.tabBar.barTintColor = UIColor.blackColor()
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
    }

    func loadData() {
        self.presentationImage.image = UIImage(named: imageName)
        self.textView.text = self.dataSource[tabID]
        navigationItem.title = self.titleName
    }
}