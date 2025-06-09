table 76012 "Commercial Setup"
{
    // ------------------------------------------------------------------------
    // No.     Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // $001    11-Junio-14     JML           Añado campo para guardar la plantilla Word para la generación de la
    //                                       Solicitud de Asistencia Técnica Pedagógica en Word.

    Caption = 'Commercial Setup';

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; "No. Serie Profesores"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3; "No. Serie Eventos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; "No. Serie Talleres"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(5; "Cod. Dimension APS"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(6; "No. Serie CDS"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; Campana; Code[10])
        {
            Caption = 'Campaign';
        }
        field(8; "Gpo. contable prod. ventas"; Code[20])
        {
            Caption = 'Sales Item posting group';
            TableRelation = "Inventory Posting Group";
        }
        field(9; "Gpo. contable prod. obsequios"; Code[20])
        {
            Caption = 'Gift Item posting group';
            TableRelation = "Inventory Posting Group";
        }
        field(10; "Cod. Alm. Muestras"; Code[20])
        {
            TableRelation = Location;
        }
        field(11; "Cod. Dimension Lin. Negocio"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(12; "Cod. Dimension Familia"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(13; "Cod. Dimension Sub Familia"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(14; "Cod. Dimension Serie"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(15; "Cod. Dimension Delegacion"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(16; "Cod. Dimension Dist. Geo."; Code[20])
        {
            TableRelation = Dimension;
        }
        field(17; "Ruta archivos electronicos"; Text[250])
        {
        }
        field(18; "No. Serie Solic. T-E"; Code[20])
        {
            Caption = 'No. Serie Request T&E';
            TableRelation = "No. Series";
        }
        field(19; "Movilidad Activada"; Boolean)
        {
        }
        field(20; "Activar control de C.P."; Boolean)
        {
            Caption = 'Activate Post Code control';
        }
        field(21; "Dim para Estad. Adopciones"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(30; "Plantilla Word sol. asis. tec."; BLOB)
        {
            Caption = 'Plantilla Word Solicitud de Asistencia Técnica Pedagógica';
            Description = '$001';
        }
        field(40; "Ruta Word sol. asis. tex."; Text[250])
        {
            Caption = 'Ruta Word Solicitud de Asistencia Técnica Pedagógica';
            Description = '$001';

            trigger OnValidate()
            begin
                if "Ruta Word sol. asis. tex."[StrLen("Ruta Word sol. asis. tex.")] <> '\' then
                    "Ruta Word sol. asis. tex." := "Ruta Word sol. asis. tex." + '\';
            end;
        }
        field(41; "Plantilla Word ficha de PPFF"; BLOB)
        {
            Caption = 'Plantilla Word ficha de PPFF';
        }
        field(42; "Ruta Word ficha de PPFF"; Text[250])
        {
            Caption = 'Ruta Word ficha de PPFF';

            trigger OnValidate()
            begin
                if "Ruta Word sol. asis. tex."[StrLen("Ruta Word sol. asis. tex.")] <> '\' then
                    "Ruta Word sol. asis. tex." := "Ruta Word sol. asis. tex." + '\';
            end;
        }
        field(43; "Campaña Ranking Solicitud"; Option)
        {
            OptionCaption = 'Vigente,Última Cerrada';
            OptionMembers = Vigente,"Última Cerrada";
        }
        field(44; "No. Serie Atenciones"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(45; "No. Serie Visita Asesor/Consu."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(46; "Plantilla Word Visitas C/A"; BLOB)
        {
            Caption = 'Plantilla Word Visitas C/A';
        }
        field(47; "Ruta Word Visitas C/A"; Text[250])
        {
            Caption = 'Ruta Word Visitas C/A';

            trigger OnValidate()
            begin
                if "Ruta Word sol. asis. tex."[StrLen("Ruta Word sol. asis. tex.")] <> '\' then
                    "Ruta Word sol. asis. tex." := "Ruta Word sol. asis. tex." + '\';
            end;
        }
        field(48; "% Dto. Padres Captiion"; Text[30])
        {
            Caption = 'Father''s discount label';
        }
        field(49; "% Dto. Colegio Caption"; Text[30])
        {
            Caption = 'School''s discount Label';
        }
        field(50; "% Dto. Docente Caption"; Text[30])
        {
            Caption = 'Teacher''s discount Label';
        }
        field(51; "% Dto. Feria Padres Caption"; Text[30])
        {
            Caption = 'Etiqueta % Dto. Feria Padres';
        }
        field(52; "% Dto. Feria Colegio Caption"; Text[30])
        {
            Caption = 'Etiqueta % Dto. Feria Colegio';
        }
        field(53; "% Dto. Donacion Plantel Captio"; Text[30])
        {
            Caption = 'Etiqueta % Dto. Donacion Plantel';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

