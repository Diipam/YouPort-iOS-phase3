//
//  TermsOfServiceViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 13/10/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: UIViewController {
    static let identifier = String(describing: TermsOfServiceViewController.self)

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var termsAndConditionTextView: UITextView!


    private var termsAndConditionText_en = ""
    private var termsAndConditionText_ja = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar(isBackButtonHidden: false, isLogoHidden: true, isSettingIconHidden: true)
        titleLabel.text = "Terms of Use".localized()
        setText()

        guard let preferredLanguage = Locale.preferredLanguages.first else {return}
        termsAndConditionTextView.text = preferredLanguage.hasPrefix("ja") ? termsAndConditionText_ja : termsAndConditionText_en
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        termsAndConditionTextView.borderWidth = 2
        termsAndConditionTextView.borderColor  = .label
        termsAndConditionTextView.cornerRadius = termsAndConditionTextView.height / 30

    }

    @objc override func pressedBackButton() {
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is MainViewController {
                    self.navigationController?.popToViewController(viewController, animated: true)
                    break
                }
            }
        }
    }

    func setText() {

        // MARK: - Terms and Condition text  -
        termsAndConditionText_en = """
Article 1 (Purpose and Application of the Terms of Use)
We, Limited Liability Company Enjini-ya (hereinafter “we, “us” or “our”) administer and operate the smartphone app “YouPort”, and hereby set forth the terms of use (hereinafter “Terms of Use”) of “YouPort” for the purpose of defining the rights and obligations of us and the App users and other terms and conditions of use of “YouPort” for the App user’s use of any and all functions provided in “YouPort”.
By downloading or using “YouPort”, the App user is deemed to have acknowledged and given consent to the content of the Terms of Use. This App is the one that provides extension function for viewing YouTube (URL: https://www.youtube.com/), and the App Users shall comply with the terms of use of YouTube.  In addition, this App must be installed in a terminal that a person of age 13 or more owns or is authorized to use, and a person of age of 13 or more must configure the setting.

Article 2 (Definitions of Terms)
The definitions of the terms used in the Terms of Use are as follows:
(1) ”App” means “YouPort” App that includes all the functions provided in “YouPort”.
(2) “App User” means all the users who use “YouPort” APP.
(3) “Intellectual Property Rights” mean the rights stipulated by the laws and regulations regarding patent rights, utility model rights, design patent rights, copyrights, trademark rights and other intellectual property rights specified by the laws and regulations or the rights to interests to be protected by the laws.

Article 3 (Use Fee)
Use fee of this App is free, provided, however, the communication fees involved in using this App are at the responsibility of the App User.

Article 4 (Revision of Terms of Use, etc.)
We may revise the Terms of Use arbitrarily without notifying in advance to the App Users.  The revised Terms of Use shall be effective as of the time when the revised Terms of Use are published on this App.  If the App User uses this App after the revision, he/she is deemed to have agreed to the content of the revised Terms of Use.

Article 5 (Handling of Personal Information)
(1) “Personal information” shall mean the “personal information” as stipulated in the “Act on the Protection of Personal Information”; and means the information about an individual who is living, which can identify the specific individual such as the name, date of birth, address, telephone number, contact information etc. included in said personal information.
(2) When the App User wants to use this App and accordingly it becomes necessary for us to identify the App user, or when we receive an inquiry from the App User and accordingly it becomes necessary for us to identify his/her contact information, we may acquire personal information such as the name, date of birth, address, etc.  For the detail of handling personal information, see our Privacy Policy (URL: https://youport.app/privacy-policy).

Article 6 (Acquisition and Use of App Use Information)
In addition to personal information as provided in Article 5, we will acquire information inputted on this App (service ID, e-mail address, etc.) and log information (position information, etc. by means of GPS) acquired via the usage of this App.

Article 7 (Disclosure of Posted Information)
If we are requested by a court, public prosecutor’s office, police or other similar public agency, or if it becomes legally necessary, we may disclose information including personal information of the App User.

Article 8 (Required Setting Before Use)
App Users must set YouTube to the restricted mode (this means the function of restricting viewing of adult contents and the like) before using this App.

Article 9 (Title)
All the intellectual property rights related to this App are owned by to us or other lawful proprietors, and use of the intellectual property rights included in the App which are owned by us or other lawful proprietor shall not be granted to the App User when the App User uses the App.

Article10 (Prohibited Acts)
The following acts by the App Users when using “YouPort” are prohibited:
(1) Acts to participate in a criminal act or fraudulent act, or to take an act that leads to said acts
(2) Acts to infringe a third party’s intellectual property right, portrait right, reputation, privacy right, other rights or interests
(3) Harmful acts to minors
(4) Acts to make false statement
(5) Acts to slander others
(6) Acts to offend public order and morals
(7) Fraudulent acts
(8) Acts to cause mental or financial damage to others
(9) Acts to use the App for commercial purposes (use, reproduction, copying, sale, etc.) (including acts to use the App for purposes other than private use)
(10) Acts to solicit insurance or other financial products
(11) Acts to upload, transmit, or write harmful computer programs, etc.
(12) Acts to modify programs, or conduct reverse engineering, decompile, or disassemble the programs
(13) Acts to duplicate or copy all or part of the App
(14) Acts to interfere with the operation of the App or undermine our credibility
(15) Acts to collect or accumulate personal information of other App Users
(16) Other acts that we deem inappropriate in light of the intended use of the App

Article11 (Indemnification for Damages)
In the event that the App User, regardless of whether or not he/she has malicious intent, violates the contents of the Terms of Use or uses the App illegally and accordingly causes damage to us, we may claim damages (including attorney's fees) against the App User.

Article 12 (Revision of Contents of the App)
We may discontinue, temporarily suspend or revise the content of the App without giving prior notice.  Even if we take such measures, we shall not be liable for any damage caused to the App User or third parties.

Article13 (Disclaimer)
We  shall not be liable for damages as listed in the followings, regarding the use of the App:
(1) Damages suffered by the App User due to use or non-availability of the App
(2) Damages caused to the App User as a result of revision of the Terms of Use, etc. (Article 4) or revision of contents of the App (Article 12)
(3) Damages caused to third parties due to use of the App by the App User
(4) Damages caused to the App User due to completeness, accuracy, sureness or usefulness etc. of the information obtained through the App
(5) Damages suffered by the App User in connection with devices used by the App User such as Internet connection line, computer, or interruption, delay, suspension, loss of data, unauthorized access to data of the system of the App, etc. caused in connection with failure of operation of software/hardware
(6) Damages such as costs incurred related to dial-up connection, unauthorized access or other costs incurred in using the App that are demanded by the telecommunication company or other communication provider
(7) Damages caused to the App User in connection with complaint, dispute, indemnification for damages, etc., due occurrence of a failure such as suspension of the server in using the App
(8) Damages suffered to the App User due to troubles on the side of YouTube
(9) Damages suffered by the App User as a result of the App User’s not complying with the Terms of Use
(10) Any and all other damages occurred in connection with use of the App

Article14 (Link to Other Websites)
We shall not be liable for any event arising out of or due to websites that have a link to the App (including those linked in the App).

Article15 (Competent Law; Jurisdiction)
The Japanese laws governs the Terms of Use, and Tokyo Summary Court or Tokyo District Court shall be the competent jurisdiction in the first instance in case of dispute between the App User and us in connection with the App or the Terms of Use.

Article 16 (Notification of Violation of Terms of Use)
If you find an act that violates the Terms of Use, please contact us.

Article 17 (Precautions; Restrictions)
The App User agrees to the precautions and restrictions as listed below in connection with use of “YouPort” before using the App.
(1) Precautions
1) Please make sure not to operate the App when walking, as it is very dangerous.
2) Please note that playing a video may involve a lot of packet communications.
(2) Restrictions
1) Playing a video involves communication fee, as such in some cases the video play function may not be available depending on the communication environment.
2) Depending on the type of the smartphone or the situation where the smartphone is operated, reading of the AR icon may take time or may occur an error.

Article 18 (Amendment of Terms of Use)
(1) We may amend the Terms of Use without the App user’s consent in any of the following events.
1) If the amendment does not substantially affect the content of the Terms of Use, such as change of the service name or wording, or correction of typo
2) If the amendment conforms to the general interests of the App Users
3) If the amendment is not contrary to the purpose for which the contract was entered and is reasonable in light of the necessity of the amendment, fitness of the content after the amendment and other circumstances in connection with the amendment
(2) In case of the amendment under the items 2 and 3 of the preceding paragraph, we will give notice regarding the amendment of the Terms of Use and the detail of the Terms of Use after the amendment, as well as the timing of entry into force thereof, by posting on our website or by other method deemed appropriate by us.  Note that, in case of the amendment under the item 1 of the preceding paragraph, the amended Terns of Use shall be effective as of the time when the content of the amended Terms of Use are posted on our website, etc. or notified by other method deemed appropriate by us
(3) The App user shall be deemed to have given consent to the amended Terms of Use without objection as of the time when the App User used the App after the amendment of the Terms of Use.

Article 19 (Severability)
If any provision of the Terms of Use or any part thereof is determined to be invalid or unenforceable under the Consumer Contract Act or other laws or regulations, the remaining provisions of the Terms of Use and the remainder of the provisions that are determined to be invalid or unenforceable shall remain in full force and effect.  We and the App User shall endeavor to modify the Terms of Use to the extent necessary to make such invalid or unenforceable provision or portion legal and enforceable, and to ensure that the intent of such invalid or unenforceable provision or portion and its legal and economic equivalence should be secured.


(Supplementary Provision) The Terms of Use are put into effect from November 20, 2022.
"""


        termsAndConditionText_ja = """
第１条（利用規約の目的及び適用）
本「YouPort」利用規約（以下「本利用規約」といいます。）は、合同会社えんじに屋（以下「当社」といいます。）が管理・運営するスマートフォンアプリ「YouPort」内で提供するあらゆる機能をアプリ利用者が利用するにあたり、当社とアプリ利用者との権利義務関係およびその他「YouPort」の利用条件等を定めることを目的とします。
「YouPort」をダウンロードもしくは使用することにより、アプリ利用者は本利用規約の内容を承認し、これに同意したものとみなされます。 なお、本アプリはYouTube（URL：https://www.youtube.com/）の閲覧にかかる拡張機能を提供するアプリであり、アプリ利用者はYouTubeの定める利用規約も遵守するものとします。また、本アプリは１３歳以上の方が所有または使用権限のある端末にインストールを行い、１３歳以上の方に設定を行っていただくものとします。

第２条（用語の定義）
本利用規約内の用語の定義は以下に示す通りとします。
①「本アプリ」とは、「YouPort」において提供しているすべての機能を含む「YouPort」アプリのことをいいます。
②「アプリ利用者」とは、「YouPort」を利用するすべての方をいいます。
③「知的財産権」とは、特許権、実用新案権、意匠権、著作権、商標権その他の知的財産権に関して法令により定 められた権利又は法律上保護される利益にかかる権利をいいます。

第３条（利用料金）
本アプリの利用料金は無料です。ただし、本アプリの利用に関わる通信料はアプリ利用者の負担となります。

第４条（本利用規約の変更等）
本利用規約は、アプリ利用者に事前に告知することなく、任意に変更できるものとします。また、変更された本利用規約の効力は、変更後の本利用規約が本アプリ上に掲載された時より生ずるものとします。 変更後に、アプリ利用者が本アプリを利用した場合には、当該変更の内容に同意したものとみなされます。

第５条（個人情報の取扱い）
①「個人情報」とは、「個人情報の保護に関する法律」にいう「個人情報」を指すものとし、生存する個人に関する 情報であって、当該情報に含まれる氏名、生年月日、住所、電話番号、連絡先その他、特定の個人を識別できる情 報を指します。
②アプリ利用者が本アプリを利用するにあたり、アプリ利用者を特定しなければならない場合や当社に問い合わせ をした際に連絡先の確認が必要となった場合などには、当社が氏名、生年月日、住所、電話番号などの個人情報を 取得することがあります。 個人情報の取扱いに関する詳細は当社のプライバシーポリシー（URLhttps://youport.app/privacy-policy）をご覧ください。

第６条（アプリ利用情報の取得・利用）
当社は第５条で定める個人情報の他に、本アプリで入力した情報（サービスＩＤ 、メールアドレス等）、本アプリ の利用を通じて得られるログ情報（GPS による位置情報等）を取得します。

第７条（掲載情報等の開示）
当社は、裁判所、検察庁、警察、又これらに準じる公的機関より要請を受けた場合、または法律上必要な場合には、アプリ利用者の個人情報を含む情報等を開示する場合があります。

第８条（利用にかかる設定）
アプリ利用者は、YouTubeの制限付きモード（成人向け等コンテンツの閲覧制限機能をいう。）に設定したうえで、本アプリを利用しなければならないものとします。

第９条（権利帰属）
本アプリに関する知的財産権は、すべて当社又は適法な権利者に帰属しているものであり、アプリ利用者が利用するにあたり、アプリ利用者に対して、当社又は適法な権利者の有する本アプリに含まれる知的財産権の利用を許可するものでありません。

第 10 条（禁止行為）
アプリ利用者の「YouPort」の利用に関しまして以下のことを禁止します。
①犯罪的行為・詐欺的行為に加担し、又はこれに結びつく行為
②当社または、第三者の知的財産権、肖像権、名誉、プライバシー権、その他の権利又は利益を侵害する行為
③未成年者を害するような行為
④虚偽の記載をする行為
⑤他人を誹謗中傷する行為
⑥公序良俗に反する行為
⑦詐欺的行為
⑧他人に精神的・経済的被害を与える行為
⑨商業目的（使用、複製、複写、販売など）で本アプリを利用する行為（本アプリを私的利用以外に用いる行為を 含みます）
⑩保険やその他金融商品の勧誘募集行為
⑪有害なコンピュータプログラム等をアップロード、送信又は書き込む行為
⑫プログラムの改変、又はリバースエンジニアリング、逆コンパイル、逆アセンブルする行為
⑬本アプリの全部又は一部を複製、複写する行為
⑭本アプリの運営を妨げ、当社の信頼を損なうような行為
⑮他のアプリ利用者の個人情報を収集したり、蓄積したりする行為
⑯その他、本アプリの利用目的に照らして当社が不適切と判断する行為

第 11 条（損害賠償）
当社は、アプリ利用者の悪意の有無に関わらず、本利用規約の内容に違反した場合や不正に本アプリを利用したこ とで、当社に損害を与えた場合には、当該アプリ利用者に対して損害賠償請求（弁護士費用を含む）を行う場合があります。

第 12 条（本アプリの内容の変更等について）
当社は、本アプリの終了、一時的な中断、又は本アプリの内容の変更などの変更を事前の告知なく行う場合があり ます。これらが行われた場合でも、当社はアプリ利用者又は第三者に生じた損害について一切責任を負わないものとします。

第 13 条（免責事項）
当社は、本アプリの利用に関して、以下に掲げる各事項の損害につきまして一切責任を負いません。
①アプリ利用者が本アプリを利用し、又は利用できなかったことに関して被った損害
②本利用規約の変更等（第４条）、本アプリの利用内容の変更等（第 12 条）によってアプリ利用者に及んだ損害
③本アプリの利用によって、アプリ利用者が第三者に及ぼした損害
④本アプリを通じて得られる情報の完全性、正確性、確実性あるいは有用性などによってアプリ利用者に及んだ損害
⑤インターネット利用回線やコンピュータ等アプリ利用者が使用する機器、ソフトウェア・ハードウェアの動作障害による本アプリにかかるシステムの中断、遅滞、中止、データの消失、データへの不正アクセスなど、その他本 アプリ利用に関してアプリ利用者に生じた損害
⑥ダイヤルアップ接続や不正アクセス、その他本アプリの利用の際に発生した電話会社又は各種通信業者より請求される接続に関する費用などの損害
⑦本アプリの利用上においてサーバー停止などの障害を発生させたことによるクレーム、紛争、損害賠償の請求などが起こった場合の損害
⑧YouTube側のトラブル等によりアプリ利用者に及んだ損害
⑨アプリ利用者が本利用規約を遵守しなかったことによりアプリ利用者に及んだ損害
⑩その他、本アプリの利用に関連して生じた一切の損害

第 14 条（他サイトへのリンクについて）
当社は、本アプリに対してリンクしているウェブサイト等（本アプリ中にリンクしているものを含む）に起因する 一切の事象に関しまして、何らの責任を負わないものとします。

第 15 条（準拠法・管轄裁判所）
本利用規約は、日本国の法令に基づくものとし、本アプリ又は本利用規約に関連して当社とアプリ利用者との間で 紛争が生じた場合、東京簡易裁判所または東京地方裁判所を第一審の専属的合意管轄裁判所とします。

第 16 条（利用規約違反の通報について）
本利用規約に違反する行為等を発見された場合には、当社までご連絡ください。

第 17 条（注意事項・制限事項）
アプリ利用者は、「YouPort」の利用に関しまして、以下に掲げる注意事項と制限事項に同意のうえ、本アプリを利用するものとします。
１　注意事項
①本アプリを歩行中に操作する行為は大変危険ですので、絶対に行わないでください。
②動画の再生には多くのパケット通信が行われる可能性があります。
２　制限事項
①動画の再生には通信が発生しますので、通信環境によっては動画再生機能が利用できない場合があります。
②スマートフォンの機種や操作される場所の状況によっては、ＡＲアイコンの読み取りに時間を要したり誤差が生じる場合があります。

第18条（規約の変更）
１　当社は、以下の各号のいずれかに該当する場合、アプリ利用者の承諾を得ることなく、本利用規約を変更できるものとします。
①変更内容がサービス名や表現の変更又は誤字、脱字の修正等であり、本利用規約の内容に実質的に影響しない場合
②変更内容がアプリ利用者の一般の利益に適合する場合
③変更内容が契約をした目的に反せず、かつ、変更の必要性、変更後の内容の相当性その他変更に係る事情に照らして合理的なものである場合
２　当社は、前項第２号及び前項第３号による変更の場合、本利用規約変更の効力発生の相当期間前までに、本利用規約を変更する旨及び変更後の本利用規約の内容並びにその効力発生時期を当社のウェブサイト等への掲載その他当社が適当と判断する方法により通知します。なお、前項第1号による変更の場合、変更後の本規約の内容を当社のウェブサイト等への掲載その他当社が適当と判断する方法により通知した時点で変更後の本利用規約の効力が発生するものとします。
３　アプリ利用者は、本規約改定後、本サービスを利用した時点で、改定後の本利用規約に異議なく同意したものとみなされます。

第19条（分離可能性）
本利用規約のいずれかの条項又はその一部が、消費者契約法その他の法令等により無効又は執行不能と判断された場合であっても、本利用規約の残りの規定及び一部が無効又は執行不能と判断された規定の残りの部分は、継続して完全に効力を有します。当社及びアプリ利用者は、当該無効若しくは執行不能の条項又は部分を適法とし、執行力を持たせるために本規約を必要な範囲で修正し、当該無効若しくは執行不能な条項又は部分の趣旨並びに法律的及び経済的に同等の効果を確保できるように努めるものとします。

（附則） 本利用規約は 2022年11月20日から実施します。
"""
    }
}

//lock the orientation to the portrait mode
extension TermsOfServiceViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }

}

