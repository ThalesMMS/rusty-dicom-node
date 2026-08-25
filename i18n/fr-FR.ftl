# Fluent catalog (fr-FR). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = Client DICOM orienté terminal, basé sur dicom-rs
cli-arg-accession-number = Filtrer par numéro d’accession (sous-chaîne, insensible à la casse).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Nom ou id du nœud de destination
cli-arg-duplicate = Filtrer par statut de doublon.
cli-arg-export = Exporter les résultats en JSON ou CSV.
cli-arg-host = Nom d’hôte ou IP
cli-arg-imported-at =
    Filtrer par horodatage d’import. Accepte VALUE, START..END, ..END, START...
        Comparaison lexicographique (format recommandé : RFC3339).
cli-arg-json = Émettre un résumé final de l’opération en JSON (schéma stable).
cli-arg-level = Niveau de requête/récupération
cli-arg-metrics-json = À la sortie, imprimer l’instantané des métriques en mémoire au format JSON.
cli-arg-modality = Filtrer par modalité. Liste séparée par des virgules (p. ex. CT,MR).
cli-arg-model = Modèle d’information requête/récupération
cli-arg-move-destination = Titre AE de destination C-MOVE préféré
cli-arg-name = Nom affiché du nœud
cli-arg-node = Nom ou id du nœud enregistré
cli-arg-notes = Notes en texte libre
cli-arg-out = Chemin du fichier de sortie. S’il est omis, écriture sur stdout.
cli-arg-path = Fichier ou répertoire à importer
cli-arg-patient-id = Filtrer par ID patient (sous-chaîne, insensible à la casse).
cli-arg-patient-name = Filtrer par nom de patient (sous-chaîne, insensible à la casse).
cli-arg-port = port TCP
cli-arg-series-description = Filtrer par description de série (sous-chaîne, insensible à la casse).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Filtrer par chemin source (sous-chaîne, insensible à la casse).
cli-arg-study-date =
    Filtrer par date d’étude. Accepte VALUE, START..END, ..END, START...
        Les dates sont comparées lexicographiquement (format recommandé : YYYYMMDD).
cli-arg-study-date-from = Borne inférieure de date d’étude (YYYYMMDD)
cli-arg-study-date-to = Borne supérieure de date d’étude (YYYYMMDD)
cli-arg-study-description = Filtrer par description d’étude (sous-chaîne, insensible à la casse).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = Importer des fichiers DICOM depuis un chemin
cli-cmd-local-about = Inspecter l’archive locale
cli-cmd-local-series-about = Lister les séries indexées d’une étude
cli-cmd-local-studies-about = Lister les études locales indexées
cli-cmd-node-about = Gérer les nœuds DICOM distants enregistrés
cli-cmd-node-add-about = Ajouter un nœud distant
cli-cmd-node-delete-about = Supprimer un nœud enregistré
cli-cmd-node-edit-about = Modifier un nœud enregistré
cli-cmd-node-list-about = Lister les nœuds enregistrés
cli-cmd-query-about = Interroger un nœud distant (C-FIND)
cli-cmd-retrieve-about = Récupérer depuis un nœud distant (C-MOVE)
cli-cmd-send-about = Envoyer des études ou séries locales (C-STORE)
cli-cmd-send-series-about = Envoyer une série vers un nœud de destination
cli-cmd-send-study-about = Envoyer une étude vers un nœud de destination
cli-cmd-serve-about = Exécuter le serveur DICOM
cli-cmd-storage-scp-about = Exécuter un écouteur Storage SCP
cli-cmd-tui-about = Ouvrir l’interface terminal interactive
cli-flag-help = Afficher l’aide
cli-flag-lang = Langue de l’interface (étiquette BCP-47). Remplace DICOM_NODE_LANG, la locale persistée et la locale système.
cli-flag-version = Afficher la version
cli-heading-arguments = Arguments :
cli-heading-commands = Commandes :
cli-heading-options = Options :
cli-heading-usage = Utilisation :
cli-import-accepted = accepted={ $n }
cli-import-complete = Import terminé
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = Annulation demandée (SIGINT). Attente d’un arrêt gracieux...
cli-msg-failures = échecs :
cli-msg-import-failed = Échec de l’import : { $error }
cli-msg-no-local-series = Aucune série indexée pour l’étude { $uid }
cli-msg-no-local-studies = Aucune étude locale indexée
cli-msg-no-saved-nodes = Aucun nœud enregistré
cli-msg-query-failed = Échec de la requête : { $error }
cli-msg-removed-nodes =
    Supprimé { $count ->
        [one] { $count } nœud
       *[other] { $count } nœuds
    }
cli-msg-results-count =
    Résultats: { $count ->
        [one] { $count } correspondance
       *[other] { $count } correspondances
    }
cli-msg-retrieve-failed = Échec de la récupération : { $error }
cli-msg-saved-node = Nœud enregistré { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Échec de l’envoi : { $error }
cli-msg-showing-failures = (affichage des { $shown } premiers sur { $total } échecs)
cli-msg-starting-server =
    Démarrage du serveur DICOM avec { $count ->
        [one] { $count } AE locale
       *[other] { $count } AE locales
    }: { $aes }
cli-msg-starting-server-no-aes = Démarrage du serveur DICOM sans AE locaux configurés
cli-msg-starting-storage-scp = Démarrage du Storage SCP à { $addr } avec le titre AE { $ae }
cli-msg-updated-node = Nœud mis à jour { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } série de plus
       *[other] { $n } séries de plus
    }
tui-row-instance-count =
    { $n ->
        [one] { $n } instance
       *[other] { $n } instances
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } nœud
       *[other] { $n } nœuds
    }
count-instances =
    { $n ->
        [one] { $n } exemplaire
       *[other] { $n } exemplaires
    }
count-series =
    { $n ->
        [one] { $n } série
       *[other] { $n } séries
    }
count-studies =
    { $n ->
        [one] { $n } étude
       *[other] { $n } études
    }
format-datetime = { $date } { $time }
format-date = { $day }/{ $month }/{ $year }

## Common
common-accession = Numéro d’accès
common-add = Ajouter
common-back = Retour
common-bytes = Octets
common-cancel = Annuler
common-clear = Effacer
common-close = Fermer
common-date = date
common-delete = Supprimer le nœud
common-description = description
common-disabled = désactivé
common-duplicates = Doublons
common-edit = Modifier
common-enabled = activé
common-error = Erreur
common-filter = Filtre
common-host = Hôte
common-import = Importer
common-instance = instance
common-language = Langue
common-loading = Chargement
common-matches = Correspondances
common-modality = Modalité
common-name = Nom
common-network = Réseau
common-no = non
common-none = aucun
common-notes = notes
common-optional = facultatif
common-path = Source
common-patient = patient
common-patient-id = ID patient
common-patient-name = Nom du patient
common-port = port TCP
common-query = Interroger
common-refresh = Actualiser
common-required = obligatoire
common-retrieve = Récupérer
common-save = Enregistrer
common-search = Rechercher
common-send = Envoyer
common-series = Séries
common-start = Démarrer
common-status = État
common-stop = Arrêter
common-studies = Études
common-study = Étude
common-unknown = inconnu
common-unknown-series = <Séries>
common-unknown-study = <Études>
common-yes = oui

## Errors
error-ae-empty = l’AE title ne peut pas être vide
error-ae-invalid-char = l’AE title contient le caractère invalide '{ $character }' ; autorisés : A-Z, 0-9, espace
error-ae-required = Le titre AE est obligatoire
error-ae-too-long = l’AE title doit comporter au plus 16 caractères
error-ae-whitespace = l’AE title ne peut pas avoir d’espaces en début ou en fin
error-archive-patient-retrieve-out-of-scope = le retrieve de niveau Patient est hors périmètre
error-archive-retrieve-uid-required = { $name } est requis pour ce niveau de retrieve
error-archive-study-root-patient-query = les requêtes Study Root ne prennent pas en charge le niveau Patient
error-archive-study-root-patient-retrieve = le retrieve Study Root ne prend pas en charge le niveau Patient
error-assoc-negotiation-failed = échec de la négociation d’association avec { $name } ({ $addr }) ; indice : vérifiez called AE title, presentation contexts/transfer syntaxes, et que le pair accepte les associations
error-assoc-no-addresses = aucune adresse de socket résolue pour { $name } à { $host }:{ $port }
error-assoc-receive = réception de l’association
error-assoc-resolving = résolution de { $name } à { $host }:{ $port } : { $err }
error-assoc-timeout = délai d’attente dépassé pour la réponse DIMSE ; indice : vérifiez le réseau, AE title/hôte/port et la réactivité du pair
error-assoc-transport = interruption de transport en attendant la réponse DIMSE ; indice : le pair a fermé la connexion ou un équipement réseau l’a réinitialisée
error-assoc-unreachable = impossible d’atteindre { $name } [{ $ae }] à { $host }:{ $port } en { $seconds }s : { $err }. Vérifiez hôte/IP, port et accessibilité réseau
error-cancel-sigint = Annulation demandée (SIGINT). Attente d’un arrêt propre...
error-config-must-be-positive = configuration invalide : { $name } doit être > 0 (ou null pour désactiver)
error-config-duplicate-bind-port = configuration invalide : port de bind d’AE locale en double { $port }
error-config-local-ae-max-assoc = configuration invalide : AE locale { $title } max_concurrent_associations doit être > 0
error-config-local-ae-no-services = configuration invalide : l’AE locale { $title } doit activer au moins un service
error-config-must-be-positive-required = configuration invalide : { $name } doit être > 0
error-dicom-meta-incomplete = le file meta DICOM est incomplet
error-dicom-patient-move-unsupported = le C-MOVE au niveau patient n’est pas pris en charge par ce client
error-dicom-required-attribute = attribut DICOM obligatoire manquant : ({ $group },{ $element })
error-dicom-series-uid-required-image = series_instance_uid est obligatoire pour le retrieve au niveau image
error-dicom-series-uid-required-series = series_instance_uid est obligatoire pour le retrieve au niveau série
error-dicom-sop-uid-required-image = sop_instance_uid est obligatoire pour le retrieve au niveau image
error-dicom-study-uid-required = study_instance_uid est obligatoire
error-dicom-validating-move = validation de la demande de move
error-export-creating-file = création du fichier d’export { $path } : { $err }
error-export-flushing-series-csv = vidage du CSV des séries : { $err }
error-export-flushing-studies-csv = vidage du CSV des études : { $err }
error-export-serializing-series-json = sérialisation JSON des séries : { $err }
error-export-serializing-studies-json = sérialisation JSON des études : { $err }
error-export-writing-series-csv-header = écriture de l’en-tête CSV des séries : { $err }
error-export-writing-series-csv-row = écriture de la ligne CSV des séries : { $err }
error-export-writing-studies-csv-header = écriture de l’en-tête CSV des études : { $err }
error-export-writing-studies-csv-row = écriture de la ligne CSV des études : { $err }
error-import-cleanup-failed = { $source } : échec du nettoyage : { $reason }
error-import-corrupt-zip = ZIP corrompu : { $details }
error-import-dicom-parse-failed = échec de l’analyse DICOM : { $err }
error-import-dicom-validation-failed = échec de la validation DICOM : { $err }
error-import-duplicate-zip-path = le ZIP contient plusieurs entrées ciblant '{ $path }'
error-import-file-too-large = fichier trop volumineux : { $details }
error-import-invalid-dicom = DICOM invalide : { $details }
error-import-limit-exceeded = { $limit } dépassé : { $details }
error-import-not-regular-file = n’est pas un fichier régulier
error-import-opening-file = ouverture du fichier : { $err }
error-import-opening-kind = ouverture de { $kind } { $path }
error-import-opening-staged-file = ouverture du fichier en staging : { $err }
error-import-opening-zip-archive = ouverture de l’archive ZIP { $path }
error-import-opening-zip-entry = ouverture de l’entrée ZIP : { $err }
error-import-opening-zip-file = ouverture du fichier ZIP d’importation { $path }
error-import-path-does-not-exist = Le chemin d’importation n’existe pas : { $path }
error-import-reading-directory = lecture du répertoire d’importation { $path }
error-import-reading-file = lecture du fichier : { $err }
error-import-reading-file-metadata = lecture des métadonnées du fichier { $path }
error-import-reading-metadata = lecture des métadonnées de { $kind } { $path }
error-import-reading-zip-entry = lecture de l’entrée ZIP : { $err }
error-import-removing-staged-after-cancel = suppression du fichier en staging après annulation { $path }
error-import-skipped = { $source } : ignoré : { $reason }
error-import-unreadable = Fichier illisible : { $details }
error-import-unsafe-zip-path = le chemin de l’entrée sort de l’archive
error-import-zip-entry-count-exceeded = limite du nombre d’entrées ZIP dépassée : l’archive a { $count } entrées, la limite est { $limit }
error-import-zip-entry-size-exceeded = la taille de l’entrée ZIP { $size } dépasse la limite { $limit }
error-import-zip-total-bytes-exceeded = limite des octets extraits du ZIP dépassée : total actuel { $current } plus taille de l’entrée { $entry } dépasse la limite { $limit }
error-net-binding-storage-scp = liaison du Storage SCP sur { $addr } pour l’AE { $ae }. Un autre récepteur DICOM local utilise peut-être déjà ce port. Mettez à jour storage_scp_port/local_aes dans { $config } ou arrêtez le listener en conflit
error-net-building-file-meta = construction de la table file meta
error-net-cannot-send-transfer-syntax = impossible d’envoyer la transfer syntax source { $source } avec la transfer syntax négociée { $negotiated }
error-net-cget-dataset-empty = le dataset C-GET C-STORE encodé est vide
error-net-cget-dataset-odd-length = le dataset C-GET C-STORE encodé s’est terminé par un fragment final de longueur impaire
error-net-cget-peer-released = le pair a libéré l’association pendant C-GET
error-net-cget-store-unexpected-dataset = fragment de dataset inattendu dans la réponse C-GET C-STORE
error-net-cget-unexpected-command = commande inattendue 0x{ $command } en attendant C-STORE-RSP
error-net-cget-unexpected-pdu = PDU inattendu pendant la sous-opération C-GET C-STORE : { $pdu }
error-net-creating-incoming-dir = création du répertoire .incoming du Storage SCP
error-net-creating-path = création de { $path }
error-net-dataset-empty = le dataset encodé est vide mais COMMAND_DATA_SET_TYPE indique qu’un dataset est requis
error-net-dataset-odd-length = le dataset encodé s’est terminé par un fragment final de longueur impaire
error-net-dimse-failed = { $operation } a échoué avec le statut 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = établissement de l’association Storage SCP
error-net-file-meta-length = lecture de la longueur File Meta Information
error-net-file-meta-tag = lecture de la balise File Meta Information
error-net-file-meta-value = saut de la valeur File Meta Information
error-net-file-meta-vr = lecture du VR File Meta Information
error-net-file-position = lecture de la position du fichier
error-net-flushing-path = vidage de { $path }
error-net-flushing-temp-dataset = vidage du fichier dataset temporaire
error-net-hint-suffix =  ; indice : { $hint }
error-net-incomplete-command = incomplet { $operation } réponse de commande
error-net-incomplete-identifier = incomplet { $operation } identifiant de réponse
error-net-invalid-affected-sop = invalide { $operation } affected SOP class UID
error-net-invalid-status = invalide { $operation } status
error-net-listener-address = lecture de l’adresse du listener Storage SCP
error-net-listener-nonblocking = passage du listener en mode nonblocking
error-net-listener-port = lecture du port du listener Storage SCP
error-net-local-aes-empty = local_aes doit contenir au moins un AE pour démarrer le Storage SCP
error-net-locating-dataset = localisation du dataset dans { $path }
error-net-malformed-dimse = mal formée { $operation } réponse DIMSE : { $details } ; indice : le pair a envoyé un command set DIMSE invalide ou inattendu
error-net-missing-affected-sop = manquant { $operation } affected SOP class UID
error-net-missing-command-field = champ de commande manquant
error-net-missing-cstore-rsp-command-field = champ de commande de la réponse C-STORE manquant
error-net-missing-cstore-rsp-status = statut de la réponse C-STORE manquant
error-net-missing-destination = destination C-MOVE manquante
error-net-missing-dicm = marqueur DICM Part 10 manquant
error-net-missing-message-id = manquant { $operation } message id
error-net-missing-qr-level = { $operation } identifiant sans QueryRetrieveLevel
error-net-missing-required-command-field = champ de commande obligatoire manquant { $name } ({ $tag })
error-net-missing-status = manquant { $operation } status
error-net-move-destination-unresolved = move_destination n’a pas été résolu
error-net-no-cget-store-context = aucun presentation context de stockage C-GET négocié pour SOP Class { $sop } et transfer syntax { $syntax }
error-net-no-compatible-context = { $path }: aucun presentation context négocié compatible pour la transfer syntax source { $syntax }
error-net-no-dimse-provider = aucun fournisseur DIMSE enregistré pour la commande 0x{ $command } et abstract syntax { $syntax }
error-net-no-presentation-context = aucun presentation context négocié
error-net-no-presentation-context-for-file = { $path }: aucun presentation context négocié
error-net-no-presentation-context-id = presentation context négocié manquant { $id }
error-net-opening-path = ouverture de { $path }
error-net-part10-preamble = lecture du préambule Part 10
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = impossible d’alimenter un fragment P-DATA dans un accumulateur complet (take() manquant)
error-net-peer-aborted = le pair a interrompu l’association pendant la sous-opération C-GET C-STORE : { $source }
error-net-peer-socket = lecture de l’adresse socket du pair Storage SCP
error-net-reading-command-dataset = lecture du dataset de commande
error-net-reading-identifier = lecture de { $operation } identifier
error-net-reading-incoming-dataset = lecture du dataset C-STORE entrant
error-net-reading-response-dataset = lecture de { $operation } response dataset
error-net-remote-aborted = le distant a interrompu l’association : { $source }
error-net-restoring-read-timeout = restauration du délai de lecture de l’association
error-net-restoring-write-timeout = restauration du délai d’écriture de l’association
error-net-rewinding-dataset = retour au premier élément du dataset
error-net-scp-thread-panicked = le thread du Storage SCP a paniqué
error-net-seeking-temp-dataset = positionnement du fichier dataset temporaire
error-net-serializing-cget-dataset = sérialisation du dataset de sous-opération C-GET pour { $path }
error-net-serializing-dataset = sérialisation du dataset pour { $path } avec transfer syntax { $syntax }
error-net-setting-socket-blocking = passage du socket de stockage accepté en mode blocking
error-net-sending-buffered-dataset = envoi du dataset en mémoire tampon pour { $path }
error-net-store-status = le distant a renvoyé le statut C-STORE 0x{ $status } ({ $meaning }){ $hint }
error-net-streaming-dataset = diffusion du dataset C-STORE
error-net-unexpected-command-field = CommandField inattendu 0x{ $actual } (attendu 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = fragment de dataset inattendu dans la réponse C-STORE
error-net-unexpected-pdu = PDU inattendu pendant { $operation }: { $pdu }
error-net-unknown-status = inconnu ou invalide { $operation } status 0x{ $status }
error-net-unsupported-model-sop = non pris en charge { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = QueryRetrieveLevel non pris en charge : { $level }
error-net-unsupported-transfer-syntax = transfer syntax négociée non prise en charge
error-net-writing-command-dataset = écriture du dataset de commande
error-net-writing-identifier = écriture de { $operation } identifier
error-net-writing-path = écriture de { $path }
error-net-writing-response-dataset = écriture de { $operation } response dataset
error-net-writing-temp-dataset = écriture des octets du dataset dans le fichier temporaire
error-node-host-empty = l’hôte du nœud ne peut pas être vide
error-node-name-empty = le nom du nœud ne peut pas être vide
error-node-not-found = nœud distant introuvable : { $id }
error-operation-cancelled = opération annulée
error-port-invalid = port invalide : { $value }
error-port-range = le port doit être compris entre 1 et 65535
error-query-no-study-uid = La correspondance n’a pas de StudyInstanceUID ; récupération impossible.
error-query-unsupported-level = niveau de requête non pris en charge : { $value }
error-query-unsupported-model = modèle de requête non pris en charge : { $value }
error-retrieve-canceled = le retrieve a été annulé par le nœud distant (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = le retrieve a échoué avec status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = le retrieve s’est terminé pour la destination { $destination } avec completed={ $completed } mais rien n’est arrivé au Storage SCP local ({ $scp }). Vérifiez le mappage AE ou le port : { $listener } doit être libre et le nœud distant doit mapper l’AE { $destination } vers cette application
error-send-no-files-series = aucun fichier local indexé pour la série { $uid }
error-send-no-files-study = aucun fichier local indexé pour l’étude { $uid }
error-task-cancelled = Tâche annulée
error-task-none-to-cancel = Aucune tâche active à annuler (rien n’est en cours)
error-tracing-init = initialisation du subscriber tracing : { $err }
error-uid-component-numeric = Le composant d’UID « { $part } » doit être numérique
error-uid-component-too-long = Le composant d’UID « { $part } » est trop long
error-uid-dot-ends = L’UID ne peut pas commencer ni se terminer par un point
error-uid-empty = L’UID ne peut pas être vide
error-uid-empty-component = L’UID ne peut pas contenir de composants vides
error-uid-leading-zeros = Le composant d’UID « { $part } » ne peut pas avoir de zéros non significatifs
error-uid-too-long = L’UID doit compter au plus 64 caractères

## TUI
tui-bool-no = non
tui-bool-off = non
tui-bool-on = oui
tui-bool-yes = oui
tui-command-placeholder = Saisissez une commande ou utilisez les raccourcis du volet.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Appuyez sur Tab pour cibler ce panneau, puis sur 'c' pour modifier.
tui-config-hint = Appuyez sur Tab pour cibler ce panneau, puis sur 'c' pour modifier.
tui-config-listener = Écoute : { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = Préférence TS : { $value }
tui-controls-hint = Tab champs · Entrée confirme · Échap annule
tui-detail-ae-title = AE Title
tui-detail-instance = Détail de l’instance
tui-detail-name = Nom
tui-detail-node = Détail du nœud
tui-detail-placeholder-followup = Déplacez le focus vers un panneau de liste et changez la sélection pour actualiser cette vue.
tui-detail-query = Détail du résultat de requête
tui-detail-select-node = Sélectionnez un nœud distant pour inspecter ses métadonnées.
tui-detail-series = Détail de la série
tui-detail-study = Détail de l’étude
tui-empty-command-placeholder = Saisissez une commande ou utilisez les raccourcis du volet.
tui-empty-detail-instance = Sélectionnez une instance pour l’inspecter, ou revenez aux séries avec Échap.
tui-empty-detail-node = Sélectionnez un nœud distant pour inspecter ses métadonnées.
tui-empty-detail-query = Sélectionnez un résultat de requête pour inspecter les métadonnées et le contexte retrieve.
tui-empty-detail-series = Sélectionnez une série pour l’inspecter, ou revenez aux études avec Échap.
tui-empty-detail-study = Sélectionnez une étude locale pour inspecter les métadonnées patient et séries.
tui-empty-instances = Aucune instance indexée n’est disponible pour cette série.
tui-empty-instances-hint = Appuyez sur Échap pour revenir aux séries.
tui-empty-local-instances = Aucune instance indexée n’est disponible pour cette série.
tui-empty-local-instances-hint = Appuyez sur Échap pour revenir aux séries.
tui-empty-local-series = Aucune série indexée n’est disponible pour cette étude.
tui-empty-local-series-hint = Appuyez sur Échap pour revenir aux études locales.
tui-empty-local-studies = Aucune étude indexée n’est encore disponible.
tui-empty-local-studies-cmd = Exemple : import path=/data/inbox
tui-empty-local-studies-hint = Importez d’abord des fichiers DICOM locaux.
tui-empty-no-name = <sans nom>
tui-empty-query = Aucune requête n’a encore été exécutée.
tui-empty-query-body =
    Sélectionnez un nœud distant et appuyez sur 'f' pour interroger.
    Ou : query node=pacs
        patient_name="DOE^JOHN"
    Appuyez sur 'm' sur un résultat sélectionné pour ouvrir retrieve.
tui-empty-query-cmd = Ou : query node=pacs
tui-empty-query-hint = Sélectionnez un nœud distant et appuyez sur 'f' pour interroger.
tui-empty-query-last-target = Dernière cible de requête : { $name }
tui-empty-query-none = Aucune requête n’a encore été exécutée.
tui-empty-query-retrieve-hint = Appuyez sur 'm' sur un résultat sélectionné pour ouvrir retrieve.
tui-empty-remote-nodes =
    Aucun nœud distant n’est encore enregistré.
    
    Appuyez sur « a » dans ce volet pour en ajouter un.
    Ou : node add name=pacs
        ae=PACSAE host=10.0.0.10
        port=104
tui-empty-remote-nodes-cmd = Ou : node add name=pacs
tui-empty-remote-nodes-hint = Appuyez sur « a » dans ce volet pour en ajouter un.
tui-empty-series = Aucune série indexée n’est disponible pour cette étude.
tui-empty-series-hint = Appuyez sur Échap pour revenir aux études locales.
tui-empty-studies = Aucune étude indexée n’est encore disponible.
tui-empty-studies-hint = Importez d’abord des fichiers DICOM locaux.
tui-empty-tasks-history = Aucun historique de tâches.
tui-empty-tasks-queued = Aucune tâche en file.
tui-fallback-no-name = <sans nom>
tui-field-accession = Numéro d’accession
tui-field-ae-title = Titre AE
tui-field-bind-addr = Adresse d’écoute
tui-field-date-from = Date de début
tui-field-date-to = Date de fin
tui-field-destination-node = Nœud de destination
tui-field-host = Hôte
tui-field-instance-uid = Instance UID
tui-field-kind = Type
tui-field-level = Niveau
tui-field-local-ae = AE local
tui-field-max-pdu = PDU max
tui-field-modality = Modalité
tui-field-model = Modèle
tui-field-move-destination = Destination C-MOVE
tui-field-name = Nom
tui-field-notes = notes
tui-field-path = Chemin
tui-field-patient-id = ID patient
tui-field-patient-name = Nom du patient
tui-field-port = port TCP
tui-field-promiscuous = Promiscuité
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = PDU strict
tui-field-study-description = Description de l’étude
tui-field-study-uid = Study UID
tui-footer-back-series = Échap retour aux séries
tui-footer-back-studies = Échap retour aux études
tui-footer-cancel-task = c annuler
tui-footer-edit-config = c modifier la config
tui-footer-enter-series = Entrée séries
tui-footer-esc-series = Échap retour aux séries
tui-footer-esc-studies = Échap retour aux études
tui-footer-help = F1/? aide
tui-footer-inspect = Entrée inspecter
tui-footer-next = Suivant : { $text }
tui-footer-nodes = a/e/d/f nœuds
tui-footer-panes = Tab volets
tui-footer-queued =
    { $n ->
        [one] { $n } en file
       *[other] { $n } en file
    }
tui-footer-quit = q quitter
tui-footer-refresh = r actualiser
tui-footer-retrieve = m récupérer
tui-footer-run-command = Entrée exécuter la commande
tui-footer-task-scope = t file/historique
tui-form-add-node = Ajouter un nœud distant
tui-form-add-remote-node = Ajouter un nœud distant
tui-form-delete-confirm = Supprimer le nœud distant { $name } [{ $ae }] à { $host }:{ $port } ?
tui-form-delete-node = Supprimer le nœud distant
tui-form-delete-remote-node = Supprimer le nœud distant
tui-form-edit-node = Modifier le nœud distant
tui-form-edit-remote-node = Modifier le nœud distant
tui-form-err-ae-required = ! AE title is obligatoire
tui-form-err-bind-required = ! bind address is obligatoire
tui-form-err-host-required = ! host is obligatoire
tui-form-err-local-ae-invalid = ! AE title local invalide : { $err }
tui-form-err-local-ae-required = ! local AE title is obligatoire
tui-form-err-modality-empty = modality ne peut pas être vide
tui-form-err-move-dest-invalid = ! AE title de destination de move invalide : { $err }
tui-form-err-name-required = ! nom du nœud is obligatoire
tui-form-err-port-required = ! port is obligatoire
tui-form-err-uid-empty = L’UID ne peut pas être vide
tui-form-err-uid-empty-component = L’UID ne peut pas contenir de composants vides
tui-form-error-line = Erreur : { $error }
tui-form-field-accession = Numéro d’accession
tui-form-field-ae-title = Titre AE
tui-form-field-bind-addr = Adresse d’écoute
tui-form-field-date-from = Date de début
tui-form-field-date-to = Date de fin
tui-form-field-dest-node = Nœud de destination
tui-form-field-destination = AE de destination
tui-form-field-host = Hôte
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Type
tui-form-field-level = Niveau
tui-form-field-local-ae = AE local
tui-form-field-modality = Modalité
tui-form-field-model = Modèle
tui-form-field-move-dest = Destination C-MOVE
tui-form-field-name = Nom
tui-form-field-notes = notes
tui-form-field-path = Chemin
tui-form-field-patient-id = ID patient
tui-form-field-patient-name = Nom du patient
tui-form-field-port = port TCP
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Description de l’étude
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = astuce : généralement 0.0.0.0 (toutes interfaces) ou 127.0.0.1
tui-form-hint-local-ae = astuce : jusqu’à 16 caractères (A-Z, 0-9, espace), p. ex. ARCHIVE_AE
tui-form-hint-move-dest = hint: facultatif; overrides the C-MOVE destination AE title
tui-form-hint-name = astuce : un libellé court (p. ex. PACS)
tui-form-import = Importer des fichiers locaux
tui-form-import-local = Importer des fichiers locaux
tui-form-import-local-files = Importer des fichiers locaux
tui-form-mode-add = create a new nœud distant
tui-form-mode-edit = update the selected nœud distant
tui-form-query-node = Interroger le nœud distant
tui-form-query-remote-node = Interroger le nœud distant
tui-form-remote-node-line = Nœud distant: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Récupérer les correspondances
tui-form-retrieve-matches = Récupérer les correspondances
tui-form-send-series = Envoyer la série
tui-form-send-study = Envoyer l’étude
tui-form-storage-intro = Modifier les paramètres locaux du Storage SCP (enregistrés dans config.json).
tui-form-storage-scp = Paramètres Storage SCP
tui-form-storage-scp-settings = Paramètres Storage SCP
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selected nœud
tui-help-c = c           Modifier les paramètres du Storage SCP (focus sur le panneau Config)
tui-help-canonical-names = Les noms canoniques correspondent aux drapeaux CLI sans '--', avec des underscores.
tui-help-close = Fermez l’aide avec Échap, F1 ou ?.
tui-help-common-commands = Commandes courantes
tui-help-config = c           Modifier les paramètres du Storage SCP (focus sur le panneau Config)
tui-help-config-path = Chemin de config : { $value }
tui-help-current-config = Configuration actuelle
tui-help-data-dir = Répertoire données : { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from Études locales
tui-help-enter-instance = Entrée       Aucune action du panneau local en vue instance
tui-help-enter-local-instance = Entrée       Aucune action du panneau local en vue instance
tui-help-enter-local-series = Entrée       Ouvrir les instances de la série locale sélectionnée, ou exécuter la saisie / valider la modale active
tui-help-enter-local-study = Entrée       Ouvrir les séries de l’examen local sélectionné, ou exécuter la saisie / valider la modale active
tui-help-enter-series = Entrée       Ouvrir les instances de la série locale sélectionnée, ou exécuter la saisie / valider la modale active
tui-help-enter-study = Entrée       Ouvrir les séries de l’examen local sélectionné, ou exécuter la saisie / valider la modale active
tui-help-esc-default = Échap         Fermer l’aide/modale, revenir des séries locales, ou ramener le focus à la saisie de commande
tui-help-esc-instance = Échap         Revenir des instances locales aux séries, fermer l’aide/modale, ou ramener le focus à la saisie
tui-help-esc-instances = Échap         Revenir des instances locales aux séries, fermer l’aide/modale, ou ramener le focus à la saisie
tui-help-esc-series = Échap         Revenir des séries locales aux examens, fermer l’aide/modale, ou ramener le focus à la saisie
tui-help-f1 = F1 or ?     Ouvrir l’aide
tui-help-import-send = i/s         Importer local files or send selected study/series
tui-help-is = i/s         Importer local files or send selected study/series
tui-help-listener = Écoute : { $value }
tui-help-log-dir = Répertoire journal : { $value }
tui-help-m = m           Récupérer depuis le résultat de requête sélectionné
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Haut/bas ou j/k   Déplacer la sélection dans les listes
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selected nœud
tui-help-open = F1 or ?     Ouvrir l’aide
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Quitter lorsqu’aucune modale n’est active et que le focus n’est pas dans la saisie de commande
tui-help-quit = q           Quitter lorsqu’aucune modale n’est active et que le focus n’est pas dans la saisie de commande
tui-help-r = r           Actualiser panes when focus is nont in command input
tui-help-receiver-mode = Mode récepteur : { $value }
tui-receiver-mode-on-demand = à la demande pour retrieve local
tui-receiver-mode-standalone = autonome via storage-scp
tui-help-refresh = r           Actualiser panes when focus is nont in command input
tui-help-retrieve = m           Récupérer depuis le résultat de requête sélectionné
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Maj-Tab  Changer le panneau ciblé
tui-help-title = Raccourcis clavier
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Haut/bas ou j/k   Déplacer la sélection dans les listes
tui-input-placeholder = Saisissez une commande ou utilisez les raccourcis du volet.
tui-log-command = > { $command }
tui-log-error = erreur : { $error }
tui-log-refreshed = actualisé
tui-logs-capped-suffix = plafonné
tui-logs-label = Journaux:
tui-pane-command = Commande
tui-pane-config = Configuration
tui-pane-detail = Détail
tui-pane-detail-hint = { $title } (PgUp/PgDn lorsque vous ne saisissez pas)
tui-pane-help = Aide
tui-pane-instance-detail = Détail de l’instance
tui-pane-instances-for = Instances pour : { $uid }
tui-pane-local-studies = Études locales
tui-pane-logs = Journaux ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = Journaux ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = Journaux ({ $shown }/{ $total })
tui-pane-node-detail = Détail du nœud
tui-pane-query-detail = Détail du résultat de requête
tui-pane-query-node = Interroger le nœud
tui-pane-query-result-detail = Détail du résultat de requête
tui-pane-query-results = Résultats requête / récupération
tui-pane-query-retrieve-results = Résultats requête / récupération
tui-pane-remote-nodes = Nœuds distants
tui-pane-series-detail = Détail de la série
tui-pane-series-for = Séries pour : { $uid }
tui-pane-series-unknown = Séries pour : <étude inconnue>
tui-pane-study-detail = Détail de l’étude
tui-pane-task-details = Détail de tâche
tui-pane-tasks-history = Tâches (historique)
tui-pane-tasks-queued = Tâches (file)
tui-pane-unknown-series = <série inconnue>
tui-pane-unknown-study = Séries pour : <étude inconnue>
tui-row-inst = inst
tui-status-cancel-requested = Annulerlation requested
tui-status-config = Configuration
tui-status-configured-listener = Écoute configurée { $addr } en AE { $ae } ({ $mode })
tui-status-data = données
tui-status-failure = échec : { $failure }
tui-status-listener = Écoute
tui-status-local-ae = AE local
tui-status-mode = mode
tui-status-mode-on-demand = à la demande
tui-status-mode-standalone = autonome
tui-status-no-active-task = Aucune tâche active to cancel (rien n’est en cours)
tui-status-pdu = PDU
tui-status-promiscuous = Promiscuité
tui-status-query-before-retrieve = Query a nœud distant first so retrieve knows which nœud to use
tui-status-query-failed = échec de la requête : { $error }
tui-status-queued-op = Opération en file : { $op }
tui-status-retrieve-failed = échec de la récupération : { $error }
tui-status-retrieve-open-failed = impossible d’ouvrir retrieve stream: { $error }
tui-status-saved-node = saved nœud { $name } ({ $id })
tui-status-saved-scp = Storage SCP settings saved (restart obligatoire)
tui-status-select-node = sélectionnez d’abord un nœud distant
tui-status-select-query = sélectionnez d’abord un résultat de requête
tui-status-select-study = sélectionnez d’abord un examen local
tui-status-strict = strict
tui-status-task-cancelled = Tâche annulée
tui-status-task-cancelled-detail = Tâche annulée : { $other }
tui-status-ts-pref = Préf. TS
tui-status-updated-node = updated nœud { $name } ({ $id })
tui-suggest-back-series = Échap — retour aux séries
tui-suggest-edit-config = c — modifier la config
tui-suggest-help = F1/? — aide
tui-suggest-inspect-task = Entrée — inspecter la tâche
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query a nœud
tui-suggest-query-node = f — query selected nœud
tui-suggest-retrieve = m — récupérer la sélection
tui-suggest-run-command = Entrée — exécuter la commande
tui-suggest-send-series = s — envoyer la série sélectionnée
tui-suggest-view-series = Entrée — voir les séries
tui-task-cancelled = Annulée
tui-task-cancelling = Annulation
tui-task-failed = Échec
tui-task-failed-generic = Échec de la tâche : { $error }
tui-task-import-done = Importer complete: { $report }
tui-task-import-failed = Échec de l’import : { $error }
tui-task-importing = Import de { $path }...
tui-task-query-done =
    Requête terminée: { $count ->
        [one] { $count } correspondance
       *[other] { $count } correspondances
    }
tui-task-query-failed = Échec de la requête : { $error }
tui-task-querying = Interrogation de { $node }...
tui-task-queued = En file
tui-task-retrieve-done = Récupération terminée : { $outcome }
tui-task-retrieve-failed = Échec de la récupération : { $error }
tui-task-retrieving = Récupération depuis { $node }...
tui-task-running = En cours
tui-task-sending-series = Envoi de la série { $uid } vers { $node }...
tui-task-sending-study = Envoi de l’étude { $uid } vers { $node }...
tui-task-send-done = Envoi terminé : { $outcome }
tui-task-status-cancelled = annulé
tui-task-status-cancelling = annulation
tui-task-status-failed = échec
tui-task-status-ok = ok
tui-task-status-queued = en file
tui-task-status-running = en cours
tui-task-succeeded = Réussi
tui-terminal-too-small = Terminal trop petit — veuillez redimensionner

## Desktop
desktop-action-activity = Activité { $count }
desktop-action-activity-empty = Activité
desktop-action-import = Importer
desktop-action-inspect-archive = Inspecter l’archive locale
desktop-action-inspect-archive-desc = Parcourez études, séries et instances, puis envoyez ou exportez.
desktop-action-manage-peers = Gérer les pairs
desktop-action-manage-peers-desc = Ajoutez et modifiez les nœuds PACS ou postes utilisés pour query, retrieve et store.
desktop-action-monitor-scp = Surveiller le Storage SCP
desktop-action-query = Interroger
desktop-action-refresh = Actualiser l’état
desktop-action-refresh-status = Actualiser l’état
desktop-action-reveal-log = Afficher le fichier journal
desktop-action-send = Envoyer
desktop-action-start-scp = Démarrer le Storage SCP
desktop-activity-empty = Aucune activité de session pour l’instant.
desktop-activity-title = Activité
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = Détails
desktop-archive-empty = L’archive locale est vide.
desktop-archive-export-fail = Échec de l’export { $scope }
desktop-archive-export-ok =
    { $rows ->
        [one] Exportée { $rows } ligne { $scope } vers { $path }.
       *[other] Exportées { $rows } lignes { $scope } vers { $path }.
    }
desktop-archive-export-studies = Exporter les études
desktop-archive-export-title = Exporter { $scope }
desktop-archive-filter = Filtrer par patient, UID, description, modalité…
desktop-archive-filter-placeholder = Filtrer par patient, UID, description, modalité…
desktop-archive-inst-abbrev = { $count } inst.
desktop-archive-instance-meta = { $bytes } · TS { $ts } · importé { $imported }
desktop-archive-instances = instances
desktop-archive-instances-heading = instances
desktop-archive-json = JSON
desktop-archive-loading = Chargement des études…
desktop-archive-no-filter-match = Aucune étude ne correspond au filtre.
desktop-archive-no-instances = Aucune instance trouvée.
desktop-archive-no-match = Aucune étude ne correspond au filtre.
desktop-archive-no-nodes = Aucun nœud
desktop-archive-no-series = Aucune série trouvée.
desktop-archive-reveal-file = Afficher le fichier
desktop-archive-select-series = Sélectionnez une série.
desktop-archive-select-study = Sélectionnez une étude.
desktop-archive-send-fail = { $label } : { $sent }/{ $attempted } envoyées, { $failed } échecs. { $failures }
desktop-archive-send-fail-title = { $label } a échoué
desktop-archive-send-ok = { $label } : { $sent }/{ $attempted } instances envoyées.
desktop-archive-send-series = Envoyer la série
desktop-archive-send-series-label = Série → { $destination }
desktop-archive-send-study = Envoyer l’étude
desktop-archive-send-study-label = Étude → { $destination }
desktop-archive-send-to = Envoyer vers
desktop-archive-series = Séries
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } exemplaire
       *[other] { $count } exemplaires
    }
desktop-archive-series-fallback = Séries
desktop-archive-studies = Études
desktop-archive-study-date = Date d’étude
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Inventaire des études, séries et instances de l’archive SQLite locale.
desktop-archive-title = Archive locale
desktop-brand-title = DICOM Node
desktop-col-description = description
desktop-col-instances = instances
desktop-col-modalities = Modalités
desktop-col-patient-id = ID patient
desktop-common-cancel = Annuler
desktop-common-clear = Effacer
desktop-common-disabled = désactivé
desktop-common-enabled = activé
desktop-common-loading = Chargement…
desktop-common-no = non
desktop-common-refresh = Actualiser
desktop-common-yes = oui
desktop-counter-assoc-accepted = Associations acceptées
desktop-counter-bytes-ingested = Octets ingérés
desktop-counter-cfind-requests = Requêtes C-FIND
desktop-counter-cmove-requests = Requêtes C-MOVE
desktop-counter-cstore-failed = C-STORE échoués
desktop-counter-cstore-stored = C-STORE stockés
desktop-dashboard-counter-assoc-accepted = Associations acceptées
desktop-dashboard-counter-bytes-ingested = Octets ingérés
desktop-dashboard-counter-c-find-requests = Requêtes C-FIND
desktop-dashboard-counter-c-move-requests = Requêtes C-MOVE
desktop-dashboard-counter-c-store-failed = C-STORE échoués
desktop-dashboard-counter-c-store-stored = C-STORE stockés
desktop-dashboard-empty-studies = Pas encore d’études locales.
desktop-dashboard-inspect-archive-body = Parcourir les études, descendre dans les séries et instances, puis envoyer ou exporter.
desktop-dashboard-inspect-archive-title = Inspecter l’archive locale
desktop-dashboard-kv-ae-title = Titre AE
desktop-dashboard-kv-data-dir = Répertoire de données
desktop-dashboard-kv-listener = Écouteur
desktop-dashboard-kv-log-file = Fichier journal
desktop-dashboard-kv-max-pdu = PDU max
desktop-dashboard-kv-promiscuous = Stockage promiscuous
desktop-dashboard-kv-server = Serveur
desktop-dashboard-kv-store-syntax = Syntaxe de store
desktop-dashboard-kv-strict-pdu = PDU strict
desktop-dashboard-listener-missing = Écouteur pas encore chargé.
desktop-dashboard-live-counters = Compteurs en direct
desktop-dashboard-loading-metrics = Chargement des métriques…
desktop-dashboard-loading-status = Chargement de l’état local…
desktop-dashboard-loading-studies = Chargement des études…
desktop-dashboard-local-node = Nœud local
desktop-dashboard-manage-peers-body = Ajouter et modifier les nœuds PACS ou stations utilisés pour requête, récupération et stockage.
desktop-dashboard-manage-peers-title = Gérer les pairs
desktop-dashboard-metric-instances = instances
desktop-dashboard-metric-nodes = Nœuds distants
desktop-dashboard-metric-series = Séries
desktop-dashboard-metric-studies = Études
desktop-dashboard-monitor-scp = Surveiller le Storage SCP
desktop-dashboard-recent-studies = Études récentes
desktop-dashboard-start-scp = Démarrer le Storage SCP
desktop-dashboard-subtitle = Archive locale, pairs réseau et activité SCP en un coup d’œil.
desktop-dashboard-title = Tableau de bord opérateur
desktop-doc-title = DICOM Node
desktop-import-accepted = Acceptés
desktop-import-accepted-bytes = Octets acceptés
desktop-import-activity-detail = { $accepted }/{ $scanned } acceptés, { $duplicates } doublons, { $bytes }
desktop-import-activity-fail = Échec de l’import
desktop-import-activity-ok = Import terminé
desktop-import-choose-archive = Choisissez une archive ZIP à importer
desktop-import-choose-dir = Choisissez un répertoire à importer
desktop-import-choose-folder = Dossier
desktop-import-choose-zip = Choisissez une archive ZIP à importer
desktop-import-cleanup = Nettoyage
desktop-import-clear-path = Effacer le chemin
desktop-import-complete = Import terminé
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = total
desktop-import-duplicates = Doublons
desktop-import-failed = Échec de l’import
desktop-import-failed-cleanup = Nettoyage échoué
desktop-import-failures = Échecs
desktop-import-failures-heading =
    { $count ->
        [one] { $count } échec :
       *[other] { $count } échecs :
    }
desktop-import-failures-more = … et { $count } de plus
desktop-import-files-progress = { $label } fichiers
desktop-import-folder = Dossier
desktop-import-invalid-dicom = DICOM invalide
desktop-import-pick-dir = Choisissez un répertoire à importer
desktop-import-pick-zip = Choisissez une archive ZIP à importer
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Rejetés
desktop-import-report = Rapport d’import
desktop-import-running = Import…
desktop-import-scanned = Analysés
desktop-import-skipped = Ignorés
desktop-import-source = source
desktop-import-start = Démarrer l’import
desktop-import-stored = Stockés
desktop-import-subtitle = Indexer des fichiers DICOM depuis des dossiers récursifs ou des archives ZIP dans l’archive locale gérée.
desktop-import-title = Importer
desktop-import-unreadable = Illisible
desktop-import-zip = ZIP
desktop-import-zip-filter = Archives ZIP
desktop-lang-label = Langue
desktop-listener-not-loaded = Écouteur pas encore chargé.
desktop-live-counters = Compteurs en direct
desktop-loading = Chargement
desktop-loading-local-status = Chargement de l’état local…
desktop-loading-metrics = Chargement des métriques…
desktop-loading-studies = Chargement des études…
desktop-local-node = Nœud local
desktop-locale-label = Langue
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } ligne chargée
       *[other] { $count } lignes chargées
    }
desktop-logs-activity-fail = Échec de l’actualisation du journal
desktop-logs-activity-ok = Journal actualisé
desktop-logs-auto = AUTOMATIQUE
desktop-logs-auto-refresh = Actualisation automatique
desktop-logs-empty = Le fichier journal est vide.
desktop-logs-found = FICHIER JOURNAL TROUVÉ
desktop-logs-lines =
    { $count ->
        [one] { $count } ligne
       *[other] { $count } lignes
    }
desktop-logs-loading = Chargement du journal…
desktop-logs-missing = Le fichier journal actif n’a pas encore été créé.
desktop-logs-refresh-failed = Échec de l’actualisation du journal
desktop-logs-refreshed = Journal actualisé
desktop-logs-reveal = Afficher
desktop-logs-subtitle = Queue bornée du fichier journal actif du bureau.
desktop-logs-tail = Queue
desktop-logs-title = Journaux
desktop-logs-truncated = TRONQUÉ
desktop-logs-waiting = EN ATTENTE DU FICHIER JOURNAL
desktop-metric-instances = instances
desktop-metric-remote-nodes = Nœuds distants
desktop-metric-series = Séries
desktop-metric-studies = Études
desktop-nav-archive = Archive locale
desktop-nav-dashboard = Tableau de bord
desktop-nav-import = Importer
desktop-nav-logs = Journaux
desktop-nav-network = Réseau
desktop-nav-nodes = Nœuds distants
desktop-nav-query = Requête / récupération
desktop-nav-server = Serveur de stockage
desktop-no-local-studies = Pas encore d’études locales.
desktop-nodes-add = Ajouter un nœud
desktop-nodes-added = Nœud « { $name } » ajouté.
desktop-nodes-ae-length = Le titre AE doit avoir 16 caractères ou moins.
desktop-nodes-ae-title = Titre AE
desktop-nodes-col-move = Dest. Move
desktop-nodes-configured = Nœuds configurés
desktop-nodes-confirm-delete = Supprimer le nœud « { $name } » ?
desktop-nodes-default-port = Port par défaut 104
desktop-nodes-delete = Supprimer le nœud
desktop-nodes-delete-title = Supprimer le nœud
desktop-nodes-deleted = Nœud « { $name } » supprimé.
desktop-nodes-edit = Modifier le nœud
desktop-nodes-edit-title = Modifier le nœud
desktop-nodes-empty = Pas encore de nœuds distants.
desktop-nodes-err-ae = Le titre AE est obligatoire.
desktop-nodes-err-ae-len = Le titre AE doit comporter au plus 16 caractères.
desktop-nodes-err-host = L’hôte est obligatoire.
desktop-nodes-err-name = Le nom est obligatoire.
desktop-nodes-err-port = Le port doit être compris entre 1 et 65535.
desktop-nodes-host = Hôte
desktop-nodes-move-dest = Destination Move
desktop-nodes-move-placeholder = Par défaut : AE local
desktop-nodes-name = Nom
desktop-nodes-need-ae = Le titre AE est obligatoire.
desktop-nodes-need-host = L’hôte est obligatoire.
desktop-nodes-need-name = Le nom est obligatoire.
desktop-nodes-notes = notes
desktop-nodes-notes-placeholder = PACS de salle de lecture
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = Par défaut : AE local
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = PACS de salle de lecture
desktop-nodes-port = port TCP
desktop-nodes-port-104 = Port par défaut 104
desktop-nodes-port-range = Le port doit être entre 1 et 65535.
desktop-nodes-save = Enregistrer les modifications
desktop-nodes-save-changes = Enregistrer les modifications
desktop-nodes-subtitle = Pairs PACS et stations pour requête, récupération et stockage.
desktop-nodes-summary = Résumé des nœuds
desktop-nodes-title = Nœuds distants
desktop-nodes-total = Nœuds totaux
desktop-nodes-updated = Nœud « { $name } » mis à jour.
desktop-nodes-with-move = Avec destination Move
desktop-promiscuous = Stockage promiscuous
desktop-query-accession = Accession nº
desktop-query-activity-detail = { $count } { $count ->
        [one] correspondance
       *[other] correspondances
    } au niveau { $level }
desktop-query-activity-fail = C-FIND { $node } a échoué
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Effacer
desktop-query-col-accession = n° d’accession
desktop-query-criteria = Critères de recherche
desktop-query-date-from = Date d’étude (début)
desktop-query-date-to = Date d’étude (fin)
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = Niveau
desktop-query-matches =
    { $count ->
        [one] { $count } correspondance
       *[other] { $count } correspondances
    }
desktop-query-missing-study-uid = La correspondance n’a pas de StudyInstanceUID ; récupération impossible.
desktop-query-modality = Modalité
desktop-query-no-matches = Aucune correspondance.
desktop-query-no-nodes = Aucun nœud configuré
desktop-query-patient-id = ID patient
desktop-query-patient-name = Nom du patient
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Interrogation…
desktop-query-remote-node = Nœud distant
desktop-query-results = Résultats
desktop-query-retrieve = Récupérer
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } a échoué
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Récupération terminée : terminées { $completed }, avertissements { $warning }, échecs { $failed }.
desktop-query-retrieve-selected = Récupérer la sélection
desktop-query-run = Lancer C-FIND
desktop-query-run-select = Lancez une requête et sélectionnez une correspondance.
desktop-query-running = Interrogation…
desktop-query-search-criteria = Critères de recherche
desktop-query-select-hint = Lancez une requête et sélectionnez une correspondance.
desktop-query-selected = Correspondance sélectionnée
desktop-query-selected-match = Correspondance sélectionnée
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Description de l’étude
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = C-FIND vers un nœud distant, inspectez les correspondances, puis C-MOVE vers l’archive locale.
desktop-query-title = Requête / récupération
desktop-recent-studies = Études récentes
desktop-scp-listening = SCP en écoute
desktop-scp-stopped = SCP arrêté
desktop-server-activity-fail = Échec du contrôle Storage SCP
desktop-server-activity-started = Storage SCP démarré
desktop-server-activity-started-detail = Écouteur démarré.
desktop-server-activity-stopped = Storage SCP arrêté
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = Aucune session active.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Associations acceptées
desktop-server-assoc-rejected = Associations rejetées
desktop-server-cfind-req-matches = Requêtes / correspondances C-FIND
desktop-server-cget-requests = Requêtes C-GET
desktop-server-cmove-requests = Requêtes C-MOVE
desktop-server-cmove-subops = Sous-opérations C-MOVE terminées / échouées
desktop-server-control-failed = Échec du contrôle Storage SCP
desktop-server-counter-bytes = Octets ingérés
desktop-server-counter-failed = C-STORE échoués
desktop-server-counter-find = Requêtes / correspondances C-FIND
desktop-server-counter-get = Requêtes C-GET
desktop-server-counter-move = Requêtes C-MOVE
desktop-server-counter-move-sub = Sous-opérations C-MOVE terminées / échouées
desktop-server-counter-received = C-STORE reçus
desktop-server-counter-stored = C-STORE stockés
desktop-server-cstore-failed = C-STORE échoués
desktop-server-cstore-received = C-STORE reçus
desktop-server-cstore-stored = C-STORE stockés
desktop-server-dimse = Compteurs DIMSE
desktop-server-failed = Échecs
desktop-server-health-loading = Chargement des métriques
desktop-server-health-ready = Prêt pour C-STORE entrant
desktop-server-health-review = Examiner les échecs
desktop-server-health-stopped = Arrêté
desktop-server-listener-started = Écouteur démarré.
desktop-server-listening = EN ÉCOUTE
desktop-server-loading-metrics = Chargement des métriques…
desktop-server-logs = Journaux
desktop-server-no-session = Aucune session active.
desktop-server-rate = +{ $rate } / sondage
desktop-server-ready = Prêt pour C-STORE entrant
desktop-server-review-failures = Examiner les échecs
desktop-server-session-ended = Session terminée : reçus { $received }, stockés { $stored }, échecs { $failed }.
desktop-server-start = Démarrer le serveur
desktop-server-started-title = Storage SCP démarré
desktop-server-stop = Arrêter le serveur
desktop-server-stopped = ARRÊTÉ
desktop-server-stopped-pill = ARRÊTÉ
desktop-server-stopped-status = Arrêté
desktop-server-stopped-title = Storage SCP arrêté
desktop-server-stored = Stockés
desktop-server-subtitle = Storage SCP autonome pour C-STORE entrant et indexation de l’archive locale.
desktop-server-title = Serveur de stockage
desktop-status-listening = en écoute
desktop-status-loading = Chargement
desktop-status-scp-listening = SCP en écoute
desktop-status-scp-stopped = SCP arrêté
desktop-status-stopped = arrêté
desktop-store-syntax = Syntaxe de store
desktop-strict-pdu = PDU strict
desktop-strip-pdu = PDU { $value }
desktop-table-accession = Numéro d’accès
desktop-table-ae-title = Titre AE
desktop-table-date = date
desktop-table-description = description
desktop-table-endpoint = Point de terminaison
desktop-table-instances = instances
desktop-table-modalities = Modalités
desktop-table-modality = Modalité
desktop-table-move-dest = Dest. Move
desktop-table-name = Nom
desktop-table-notes = notes
desktop-table-patient = patient
desktop-table-patient-id = ID patient
desktop-table-series = Séries
desktop-table-updated = Mis à jour
desktop-title-refresh-status = Actualiser l’état
desktop-title-reveal-log = Afficher le fichier journal
ae = AE
patient-name =
    "DOE^JOHN"
    Appuyez sur 'm' sur un résultat sélectionné pour ouvrir retrieve.
port = port TCP

## Summary
summary-ae = AE
summary-counts = Compteurs
summary-criteria = Critères
summary-duration = Durée
summary-duration-ms = { $ms }ms
summary-failures = Échecs :
summary-kind = Type
summary-logs = Journaux :
summary-peer = Pair
summary-status = État
summary-title = Résumé de l’opération
tui-detail-created = Créé

tui-form-hint-port-range = astuce : un nombre de 1 à 65535, p. ex. 104
tui-form-hint-promiscuous = astuce : autoriser le stockage depuis n’importe quel AE title appelant
tui-form-hint-strict-pdu = astuce : appliquer les contrôles de taille PDU pendant les associations
tui-form-hint-max-pdu-bytes = astuce : octets, p. ex. 16384
tui-form-limits-heading = Limits (bytes; blank/aucun = unlimited):
tui-form-field-max-file-import = Octets max. d’import de fichier
tui-form-field-max-zip-entry = Octets max. d’entrée ZIP
tui-form-field-max-zip-total = Octets totaux max. ZIP
tui-form-field-max-zip-count = Nombre max. d’entrées ZIP
tui-form-field-max-store-object = Octets max. d’objet stocké
tui-form-unlimited = illimité
tui-form-err-max-pdu-required = ! max PDU length is obligatoire
tui-form-err-max-pdu-gt-zero = ! la longueur max. de PDU doit être un entier supérieur à 0
tui-form-err-limit-gt-zero = ! { $label } doit être un entier supérieur à 0
tui-form-controls-scp = Tapez pour modifier. Espace bascule les cases. Tab/Maj-Tab ou Haut/Bas change de champ. Entrée enregistre. Échap annule.
tui-form-submit-uid-required = UID is obligatoire
tui-form-submit-dest-required = destination nœud is obligatoire
tui-form-submit-nonneg-int = { $label } doit être un entier non négatif
tui-form-submit-gt-zero = { $label } doit être supérieur à 0
tui-form-submit-local-ae-required = local AE title is obligatoire
tui-form-submit-local-ae-invalid = l’AE title local est invalide : { $err }
tui-form-submit-bind-required = bind address is obligatoire
tui-form-submit-port-required = port is obligatoire
tui-form-submit-max-pdu-required = max PDU length is obligatoire
tui-form-submit-max-pdu-int = la longueur max. de PDU doit être un entier
tui-form-submit-max-pdu-gt-zero = la longueur max. de PDU doit être supérieure à 0
tui-form-submit-patient-retrieve = la récupération au niveau patient n’est pas prise en charge
tui-form-submit-no-study-uid = le résultat sélectionné n’inclut pas de study UID
tui-form-submit-date-format = attendu : YYYYMMDD
tui-form-submit-modality-len = la modalité doit faire au plus 16 caractères
tui-form-submit-modality-chars = la modalité doit être A-Z ou 0-9
tui-form-submit-name-required = nom du nœud is obligatoire
tui-form-submit-ae-required = AE title is obligatoire
tui-form-submit-host-required = host is obligatoire
tui-form-submit-move-dest-invalid = l’AE title de destination de move est invalide : { $err }
tui-form-submit-dates-both = il faut renseigner date de début et date de fin, ou aucune
tui-form-submit-date-from-invalid = la date de début est invalide : { $err }
tui-form-submit-date-to-invalid = la date de fin est invalide : { $err }
tui-form-submit-date-order = la date de début doit être antérieure ou égale à la date de fin
tui-form-submit-study-uid-series-query = study UID is obligatoire for series-level queries
tui-form-submit-study-uid-image-query = study UID is obligatoire for image-level queries
tui-form-submit-series-uid-image-query = series UID is obligatoire for image-level queries
tui-form-submit-study-uid-required = study UID is obligatoire
tui-form-submit-study-uid-invalid = le study UID est invalide : { $err }
tui-form-submit-series-uid-series-retrieve = series UID is obligatoire for series-level retrieve
tui-form-submit-series-uid-image-retrieve = series UID is obligatoire for image-level retrieve
tui-form-submit-instance-uid-image-retrieve = instance UID is obligatoire for image-level retrieve
tui-form-submit-series-uid-invalid = le series UID est invalide : { $err }
tui-form-submit-instance-uid-invalid = l’instance UID est invalide : { $err }
tui-form-submit-import-path-required = import path is obligatoire
tui-form-submit-import-path-type = le chemin d’import doit être un fichier ou un répertoire : { $path }
tui-form-submit-import-access = accès au chemin d’import { $path }
tui-form-submit-import-open = ouverture du fichier d’import { $path }
tui-form-submit-import-read-dir = lecture du répertoire d’import { $path }
tui-log-welcome = Press F1 or ? for help. Focus Nœud distants and press 'a' to add one.
tui-log-logging-to = Journalisation vers { $path }
tui-command-help-heading = commandes :
tui-command-help-next-1 = note : le pied de page affiche des suggestions 'Next:' selon le volet actif et la sélection.
tui-command-help-next-2 = Ce ne sont que des indices ; vous pouvez toujours saisir n'importe quelle commande.
tui-command-help-canonical = note : les noms canoniques correspondent aux drapeaux CLI sans '--', avec des underscores.
tui-command-help-cancel = cancel (alias : stop)
tui-command-help-cmds =
    {"  node add name=<n> ae=<AE> (or ae_title=<AE>) host=<host> port=<port>"}{"\u000A"}
    {"           [dest=<AE> (or move_destination=<AE>)] [notes=..]"}{"\u000A"}
    {"  node edit target=<id|name> [name=..] [ae=<AE> (or ae_title=<AE>)]"}{"\u000A"}
    {"            [host=..] [port=..] [dest=<AE> (or move_destination=<AE>)] [notes=..]"}{"\u000A"}
    {"  node delete target=<id|name> (or id=<id> / name=<name>)"}{"\u000A"}
    {"  import path=<folder|file|zip>"}{"\u000A"}
    {"  query node=<name> [model=patient|study] [level=patient|study|series|image]"}{"\u000A"}
    {"        [patient_name=..] [patient_id=..] [accession=<n> (or accession_number=<n>)]"}{"\u000A"}
    {"        [study_uid=<uid> (or study_instance_uid=<uid>)]"}{"\u000A"}
    {"        [series_uid=<uid> (or series_instance_uid=<uid>)]"}{"\u000A"}
    {"        [instance_uid=<uid> (or sop_instance_uid=<uid>)]"}{"\u000A"}
    {"        [date_from=YYYYMMDD (or study_date_from=YYYYMMDD)]"}{"\u000A"}
    {"        [date_to=YYYYMMDD (or study_date_to=YYYYMMDD)] [modality=..] [study_description=..]"}{"\u000A"}
    {"  retrieve node=<name> study_uid=<uid> (or study_instance_uid=<uid>)"}{"\u000A"}
    {"           [series_uid=.. (or series_instance_uid=..)]"}{"\u000A"}
    {"           [instance_uid=.. (or sop_instance_uid=..)]"}{"\u000A"}
    {"           [dest=<AE> (or move_destination=<AE>)]"}{"\u000A"}
    {"  send-study node=<name> (or destination_node=<name>)"}{"\u000A"}
    {"             study_uid=<uid> (or study_instance_uid=<uid> or study=<uid>)"}{"\u000A"}
    {"  send-series node=<name> (or destination_node=<name>)"}{"\u000A"}
    {"              series_uid=<uid> (or series_instance_uid=<uid> or series=<uid>)"}{"\u000A"}
    {"  local studies [patient_name=..] [patient_id=..] [study_description=..]"}{"\u000A"}
    {"              [study_date=VALUE|START..END|START..|..END]"}{"\u000A"}
    {"              [modality=CT,MR,..] [imported_at=VALUE|START..END|START..|..END]"}{"\u000A"}
    {"              [duplicate=true|false]"}{"\u000A"}
    {"  local series study_uid=<uid> (or study_instance_uid=<uid> or study=<uid>)"}{"\u000A"}
    {"  local instances series_uid=<uid> (or series_instance_uid=<uid> or series=<uid>)"}
tui-command-help-refresh = actualiser
tui-command-help-quit = quitter
tui-inspect-task = Tâche #{ $id }
tui-inspect-status = État : { $status }
tui-inspect-description = Description : { $description }
tui-inspect-progress = Progression : { $progress }
tui-inspect-summary = Résumé :
tui-inspect-no-logs = (aucun journal)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    supprimé { $count ->
        [one] { $count } nœud
       *[other] { $count } nœuds
    }
tui-status-removed-nodes-target =
    supprimé { $count ->
        [one] { $count } nœud
       *[other] { $count } nœuds
    }; dernière cible { $name }
tui-status-more-failures =
    et { $n ->
        [one] { $n } échec omis
       *[other] { $n } échecs omis
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = Démarrage de la requête vers { $node }
tui-log-retrieve-start = Démarrage de la récupération depuis { $node }
tui-log-import-start = Démarrage de l’import de { $path }
tui-log-send-study-start = Démarrage de l’envoi de l’examen { $uid } vers { $node }
tui-log-send-series-start = Démarrage de l’envoi de la série { $uid } vers { $node }
tui-log-cancelled-before-start = annulé avant le démarrage
tui-log-cancelled = annulé
error-unknown-command = commande inconnue : { $command }
error-node-subcommand-required = node subcommand obligatoire
error-local-subcommand-required = local subcommand obligatoire
error-unsupported-node-subcommand = unsupported nœud subcommand: { $command }
error-unsupported-local-subcommand = sous-commande local non prise en charge : { $command }
error-expected-kv = argument key=value attendu, reçu { $arg }
error-missing-required-arg = missing obligatoire argument: { $key }
error-missing-required-arg-one-of = missing obligatoire argument: one of { $keys }
error-parsing-command = analyse de la commande
error-edit-form-lost-target = edit form lost its target nœud
error-task-already-running = une tâche d’arrière-plan est déjà en cours
error-task-thread-launch = échec du lancement du fil de tâche d’arrière-plan : { $error }
error-task-disconnected = le fil de tâche d’arrière-plan s’est déconnecté avant d’envoyer un résultat
error-task-kind-missing = le fil de tâche d’arrière-plan s’est déconnecté mais active_task_kind était None : état inattendu
error-serve-exited = serve s’est arrêté avec une erreur : { $error }
cli-msg-node-list-row = { $name } [{ $id }]  { $ae }@{ $host }:{ $port }  move_dest={ $dest }
cli-msg-local-study-row = { $uid } | patient={ $patient } | date={ $date } | desc={ $desc } | modalities={ $modalities } | series={ $series } | instances={ $instances }
cli-import-unreadable = unreadable={ $n }
cli-import-invalid-dicom = invalid_dicom={ $n }
cli-import-rejected-total = rejected_total={ $n }
cli-import-skipped = skipped={ $n }
cli-import-failed-cleanup = failed_cleanup={ $n }
cli-import-total = total={ $n }
cli-import-stored-bytes = stored_bytes={ $n }
cli-import-dup-detail = duplicates={ $n } (by_sop_instance_uid={ $sop }, by_sha256={ $sha })
summary-title = Résumé de l’opération
summary-kind = Type
summary-status = État
summary-duration = Durée
summary-duration-ms = { $ms }ms
summary-peer = Pair
summary-ae = AE
summary-criteria = Critères
summary-counts = Compteurs
summary-failures = Échecs :
summary-logs = Journaux :
summary-unserializable = <non sérialisable>
summary-log-lines = lignes { $start }-{ $end }
