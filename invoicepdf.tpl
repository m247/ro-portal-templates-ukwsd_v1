<?php

$pdf->setPrintFooter(false);

$pdf->Image(ROOTDIR . '/templates/ukwsd/img/logo.png', 15, 25, 75);

$rightxpos = "145";

$pdf->SetFont('helvetica','B',9);
$pdf->SetXY($rightxpos,10);
$pdf->Cell(0,4,trim($companyaddress[0]),0,1,'L');
$pdf->SetFont('helvetica','',9);
$address = '';
for ( $i = 1; $i <= count($companyaddress); $i += 1) {
    $address .= trim($companyaddress[$i])."\n";
}
$pdf->SetXY($rightxpos,$pdf->GetY());
$pdf->MultiCell(140,4,$address,0,'L');
$pdf->SetXY($rightxpos,$pdf->GetY()-2);
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(20,4,"Tel:",0,0,'L');
$pdf->SetFont('helvetica','',9);
$pdf->Cell(30,4,"0161 615 4360",0,1,'L');
$pdf->SetXY($rightxpos,$pdf->GetY());
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(20,4,"Fax:",0,0,'L');
$pdf->SetFont('helvetica','',9);
$pdf->Cell(30,4,"0161 615 4360",0,1,'L');
$pdf->SetXY($rightxpos,$pdf->GetY());
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(20,4,"Email:",0,0,'L');
$pdf->SetFont('helvetica','',9);
$pdf->Cell(30,4,"billing@ukwsd.com",0,1,'L');
$pdf->SetXY($rightxpos,$pdf->GetY()+2);
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(20,4,"VAT No:",0,0,'L');
$pdf->SetFont('helvetica','',9);
$pdf->Cell(30,4,"GB 125 5100 58",0,1,'L');

$pdf->SetXY($rightxpos,$pdf->GetY()+5);
$pdf->SetFont('helvetica','B',24);
$pdf->Cell(0,0,"INVOICE",0,1,'L');

$invoicetostartypos = $pdf->GetY();

$pdf->SetXY($rightxpos,$pdf->GetY()+5);
if ($status=="Cancelled") {
    $statustext = $_LANG["invoicescancelled"];
    $pdf->SetTextColor(207);
} elseif ($status=="Unpaid") {
    $statustext = $_LANG["invoicesunpaid"];
    $pdf->SetTextColor(153,0,0);
} elseif ($status=="Paid") {
    $statustext = $_LANG["invoicespaid"];
    $pdf->SetTextColor(0,153,0);
} elseif ($status=="Refunded") {
    $statustext = $_LANG["invoicesrefunded"];
    $pdf->SetTextColor(0,0,153);
} elseif ($status=="Collections") {
    $statustext = $_LANG["invoicescollections"];
    $pdf->SetTextColor(253,121,4);
}

$pdf->SetFont('helvetica','B',16);
$pdf->Cell(0,0,strtoupper($statustext),0,1,'L');

$pdf->SetTextColor(0);

$pdf->SetFont('helvetica','',9);
$pdf->SetXY($rightxpos,$pdf->GetY()+5);
$pdf->Cell(20,4,"Invoice No:",0,0,'L');
$pdf->Cell(30,4,"$invoicenum",0,1,'L');
$pdf->SetXY($rightxpos,$pdf->GetY());
$pdf->Cell(20,4,"Invoice Date:",0,0,'L');
$pdf->Cell(30,4,"$datecreated",0,1,'L');
$pdf->SetXY($rightxpos,$pdf->GetY());
$pdf->Cell(20,4,"Due Date:",0,0,'L');
$pdf->Cell(30,4,"$duedate",0,1,'L');

$lowestypos = $pdf->GetY();

$pdf->SetXY(15,$invoicetostartypos);
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(0,4,"Invoiced To:",0,1,'L');
$pdf->SetFont('helvetica','',9);
if ($clientsdetails["companyname"]) {
    $pdf->Cell(0,4,"FAO: ".$clientsdetails["firstname"]." ".$clientsdetails["lastname"],0,1,'L');
    $pdf->Cell(0,4,$clientsdetails["companyname"],0,1,'L');
} else {
    $pdf->Cell(0,4,$clientsdetails["firstname"]." ".$clientsdetails["lastname"],0,1,'L');
}
$pdf->Cell(0,4,$clientsdetails["address1"],0,1,'L');
if ($clientsdetails["address2"]) $pdf->Cell(0,4,$clientsdetails["address2"],0,1,'L');
$pdf->Cell(0,4,$clientsdetails["city"],0,1,'L');
$pdf->Cell(0,4,$clientsdetails["state"],0,1,'L');
$pdf->Cell(0,4,$clientsdetails["postcode"],0,1,'L');
$pdf->Cell(0,4,$clientsdetails["country"],0,1,'L');
if ($customfields) {
    $pdf->Ln();
    foreach ($customfields AS $customfield) {
        $pdf->Cell(0,4,$customfield['fieldname'].': '.$customfield['value'],0,1,'L');
    }
}

if ($pdf->GetY()>$lowestypos) {
    $pdf->Ln(5);
} else {
    $pdf->SetXY(15,$lowestypos+5);
}

$pdf->SetDrawColor(207);
$pdf->SetFillColor(229);

$pdf->SetFont('helvetica','B',9);
$pdf->Cell(150,6,$_LANG["invoicesdescription"],1,0,'L','1');
$pdf->Cell(30,6,$_LANG["invoicesamount"],1,0,'L','1');
$pdf->Ln();

$pdf->SetFont('helvetica','',9);

foreach ($invoiceitems AS $item) {

    $rowcount = $pdf->getNumLines($item['description'], 140);

    $pdf->MultiCell(150,$rowcount * 6,$item['description'],1,'L',0,0);
    $pdf->MultiCell(30,$rowcount * 6,$item['amount'],1,'R',0,0);

    $pdf->Ln();
}

$pdf->SetFont('helvetica','B',9);
$pdf->Cell(150,6,$_LANG["invoicessubtotal"],1,0,'R',1);
$pdf->SetFont('helvetica','',9);
$pdf->Cell(30,6,$subtotal,1,1,'R');

if ($taxname) {
    $pdf->SetFont('helvetica','B',9);
    $pdf->Cell(150,6,$taxname." @ ".$taxrate."%",1,0,'R',1);
    $pdf->SetFont('helvetica','',9);
    $pdf->Cell(30,6,$tax,1,1,'R');
}

if ($taxname2) {
    $pdf->SetFont('helvetica','B',9);
    $pdf->Cell(150,6,$taxname2." @ ".$taxrate2."%",1,0,'R',1);
    $pdf->SetFont('helvetica','',9);
    $pdf->Cell(30,6,$tax2,1,1,'R');
}

$pdf->SetFont('helvetica','B',9);
$pdf->Cell(150,6,$_LANG["invoicescredit"],1,0,'R',1);
$pdf->SetFont('helvetica','',9);
$pdf->Cell(30,6,$credit,1,1,'R');

$pdf->SetFont('helvetica','B',9);
$pdf->Cell(150,6,$_LANG["invoicestotal"],1,0,'R',1);
$pdf->SetFont('helvetica','',9);
$pdf->Cell(30,6,$total,1,1,'R');

$pdf->Ln(15);

$pdf->SetDrawColor(207);
$pdf->SetFillColor(229);

$pdf->SetFont('helvetica','B',9);
$pdf->Cell(40,6,$_LANG["invoicestransdate"],1,0,'C','1');
$pdf->Cell(50,6,$_LANG["invoicestransgateway"],1,0,'C','1');
$pdf->Cell(50,6,$_LANG["invoicestransid"],1,0,'C','1');
$pdf->Cell(40,6,$_LANG["invoicestransamount"],1,0,'C','1');
$pdf->Ln();

$pdf->SetFont('helvetica','',9);

if (!count($transactions)) {

    $pdf->Cell(180,6,$_LANG["invoicestransnonefound"],1,0,'C');
    $pdf->Ln();

} else {

    foreach ($transactions AS $trans) {

        $pdf->Cell(40,6,$trans['date'],1,0,'C');
        $pdf->Cell(50,6,$trans['gateway'],1,0,'C');
        $pdf->Cell(50,6,$trans['transid'],1,0,'C');
        $pdf->Cell(40,6,$trans['amount'],1,0,'C');
        $pdf->Ln();

    }

}

$pdf->SetFont('helvetica','B',9);
$pdf->Cell(40,6,'',1,0,'C','1');
$pdf->Cell(50,6,'',1,0,'C','1');
$pdf->Cell(50,6,$_LANG["invoicesbalance"],1,0,'C','1');
$pdf->Cell(40,6,$balance,1,0,'C','1');

$pdf->Ln(15);

if ($notes) {
    $pdf->SetFont('helvetica','',8);
    $pdf->MultiCell(170,5,$_LANG["invoicesnotes"].": $notes");
}

$pdf->AddPage();

$pdf->SetFillColor(245);

$startypos = $pdf->GetY();
$startpage = $pdf->GetPage();
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(0,4,"Payment by Credit/Debit Card",'LTR',1,'L',1);
$pdf->SetFont('helvetica','0',9);
$pdf->Cell(0,4,"Card payments are applied instantly to your account, you can make your payment from your client area.",'LRB',1,'L',1);
$endypos = $pdf->GetY();
$endpage = $pdf->GetPage();
$pdf->Ln(6);

#if ($pdf->GetY()>210) $pdf->AddPage();

$startypos = $pdf->GetY();
$startpage = $pdf->GetPage();
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(0,4,"Payment by Bank Transfer (BACS)",'LTR',1,'L',1);
$pdf->SetFont('helvetica','0',9);
$pdf->Cell(0,4,"Please quote the invoice number [$invoicenum] as your reference when making your payment.",'LR',1,'L',1);
$pdf->Cell(0,2,"",'LR',1,'L',1);
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(40,4,"Bank:",'L',0,'L',1);
$pdf->SetFont('helvetica','',9);
$pdf->Cell(140,4,"Santander UK plc",'R',1,'L',1);
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(40,4,"Address:",'L',0,'L',1);
$pdf->SetFont('helvetica','',9);
$pdf->Cell(140,4,"2 Triton Square, Regent's Place",'R',1,'L',1);
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(40,4,"",'L',0,'L',1);
$pdf->SetFont('helvetica','',9);
$pdf->Cell(140,4,"London",'R',1,'L',1);
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(40,4,"",'L',0,'L',1);
$pdf->SetFont('helvetica','',9);
$pdf->Cell(140,4,"NW1 3AN, United Kingdom",'R',1,'L',1);
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(40,4,"Account Name:",'L',0,'L',1);
$pdf->SetFont('helvetica','',9);
$pdf->Cell(140,4,"UK Web Solutions Direct Limited",'R',1,'L',1);
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(40,4,"Sort Code:",'L',0,'L',1);
$pdf->SetFont('helvetica','',9);
$pdf->Cell(140,4,"09-02-22",'R',1,'L',1);
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(40,4,"Account Number:",'L',0,'L',1);
$pdf->SetFont('helvetica','',9);
$pdf->Cell(140,4,"10962013",'R',1,'L',1);
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(40,4,"SWIFT:",'L',0,'L',1);
$pdf->SetFont('helvetica','',9);
$pdf->Cell(140,4,"ABBYGB2LXXX",'R',1,'L',1);
$pdf->SetFont('helvetica','B',9);
$pdf->Cell(40,4,"IBAN:",'L','R','L',1);
$pdf->SetFont('helvetica','',9);
$pdf->Cell(140,4,"GB52 ABBY 090222 10962013",'R',1,'L',1);
$pdf->Cell(0,2,"",'LR',1,'L',1);
$pdf->Cell(0,4,"Allow up to 3 working days for the payment to reach your account.",'LRB',1,'L',1);
$endypos = $pdf->GetY();
$endpage = $pdf->GetPage();

?>
