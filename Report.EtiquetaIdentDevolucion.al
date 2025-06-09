report 56017 "Etiqueta Ident. Devolucion"
{
    DefaultLayout = RDLC;
    RDLCLayout = './EtiquetaIdentDevolucion.rdlc';

    dataset
    {
        dataitem("Lin. Ident. Devolución Reg."; "Lin. Ident. Devolución Reg.")
        {
            column(CI_Name; CI.Name)
            {
            }
            column(CI_Address; CI.Address)
            {
            }
            column(CI__Address_2________CI_City; CI."Address 2" + ' ' + CI.City)
            {
            }
            column(Cust__No__; Cust."No.")
            {
            }
            column(Cust_Name; Cust.Name)
            {
            }
            column(Cust_Address; Cust.Address)
            {
            }
            column(Cust__Address_2_; Cust."Address 2")
            {
            }
            column(Cust_City; Cust.City)
            {
            }
            column(Cust_County; Cust.County)
            {
            }
            column(FORMAT__No__Bulto_______FORMAT_CID__Cantidad_de_Bultos__; Format("No. Bulto") + '/' + Format(CID."Cantidad de Bultos"))
            {
            }
            column(Lin__Ident__Devolucion_Reg__Ubicacion; Ubicacion)
            {
            }
            column(No__Ident__Devolucion_____; '*' + "No. Ident. Devolucion" + '*')
            {
            }
            column(Lin__Ident__Devolucion_Reg___No__Ident__Devolucion_; "No. Ident. Devolucion")
            {
            }
            column(CID__Fecha_Recepcion_; CID."Fecha Recepcion")
            {
            }
            column(Destinatario_Caption; Destinatario_CaptionLbl)
            {
            }
            column(Orden_de_Recogida__Caption; Orden_de_Recogida__CaptionLbl)
            {
            }
            column(Fecha_de_Recepcion__Caption; Fecha_de_Recepción__CaptionLbl)
            {
            }
            column(No__Cliente__Caption; No__Cliente__CaptionLbl)
            {
            }
            column(BultoCaption; BultoCaptionLbl)
            {
            }
            column(UbicacionCaption; UbicaciónCaptionLbl)
            {
            }
            column(Lin__Ident__Devolucion_Reg__No__Bulto; "No. Bulto")
            {
            }

            trigger OnAfterGetRecord()
            begin
                CID.Get("No. Ident. Devolucion");
                Cust.Get(CID."Cod. Cliente");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CI.Get;
    end;

    var
        CI: Record "Company Information";
        Cust: Record Customer;
        CID: Record "Cab. Ident. Devolución Reg.";
        Destinatario_CaptionLbl: Label 'Destinatario:';
        Orden_de_Recogida__CaptionLbl: Label 'Orden de Recogida :';
        "Fecha_de_Recepción__CaptionLbl": Label 'Fecha de Recepción :';
        No__Cliente__CaptionLbl: Label 'No. Cliente :';
        BultoCaptionLbl: Label 'Bulto';
        "UbicaciónCaptionLbl": Label 'Ubicación';
}

