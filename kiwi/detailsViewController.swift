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

    let dataSource = ["222":"H-FARM è una piattaforma nata con l’obiettivo di aiutare giovani imprenditori nel lancio di piccole imprese innovative nel settore internet e di supportare la trasformazione delle aziende italiane in un’ottica digitale. \n\nIl modello di accelerazione delle imprese dura in media 36 mesi, durante i quali H-FARM investe e supporta il percorso di crescita di queste realtà. \n\nH-FARM ha sede nella tenuta agricola di Ca’ Tron (a 10 minuti da Venezia), Seattle (USA), Mumbai (India) e Londra (UK). Nei primi 9 anni, H-FARM ha investito circa € 18.2 milioni in 64 startup, creando oltre 390 nuovi posti di lavoro. \nIl fatturato aggregato delle aziende supera i 30 milioni di euro. \nTra il 2014-2018 sono previsti investimenti per ulteriori 10 milioni di euro.",

        "111":"LIFE è un’agenzia specializzata nell’interazione e nell’innovazione digitale.\nLa nostra offerta si basa su 3 azioni principali: \n1. Design (Experience Design, Interaction Design, Service Design); \n\n2. Strategy (Digital Strategy, Social Business Strategy, Innovation Management); \n\n3. Tech (Digital Platforms, Web & Mobile Apps, Enterprise Platforms). \n\nLIFE vuole creare servizi ed esperienze di brand capaci di migliorare la vita del consumatore e ampliare le performance di business dell’azienda. \nStiamo lavorando con brand italiani e internazionali come Autogrill, Bottega Veneta, Diesel, Ernst & Young, Generali, RCS Media Group, Vodafone e con startup innovative come Henable, XYZE, Pathflow, Love the Sign.",

        "333":"KIWI: L\'esperienza d\'acquisto interattiva a portata di smartphone. \n\nIl progetto Kiwi, regala al cliente del mondo retail un'esperienza d'acquisto nuova e coinvolgente all'interno dello store. \nGrazie all'utilizzo dei beacons, disposti all'interno del punto vendita, il consumatore potrà vivere un'esperienza interattiva e personalizzata capace di veicolare con contenuti digitali la storia del prodotto, esaltando italianità-artiginalità e unicità, il tutto con un forte coinvolgimento emotivo.",

        "444":"Dicono che le grandi idee, arrivino dalla pancia e si concretizzino davanti ad una tavola imbandita.\nMeglio ancora se imbandita con dell’ottimo cibo fatto al momento e su quello la serra è imbattibile, ci coccola ogni giorno con spuntini che farebbero invidia alle grandi cucine stellate del mondo.\n\nLa serra è il cuore dinamico di H-FARM: dalle prime luci del giorno è sempre popolato dalla community di oltre 400 tra giovani imprenditori, developers, designers e creativi.",

        "555":"All’inizio c’erano i fori, dove le idee venivano divulgate e condivise, per crescere e diventare forti e popolari, oggi ci sono le sale conferenze.\nSe è vero che ogni ufficio ha la sua sala conferenze o dovrebbe averla, qui in H-FARM il convivium è un fasto di un’epoca passata, il palcoscenico, il trampolino di lancio, che da anni promuove idee persone e gruppi.\n\nE’ il punto di riferimento per accogliere chi vuole parlare e ragionare di innovazione: workshop, conferenze, talk, i nostri demo day, trovano tutti sede qui."]
    
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