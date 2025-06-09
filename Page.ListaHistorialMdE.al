page 56202 "Lista Historial MdE"
{
    ApplicationArea = all;
    // #81969 27/01/2018 PLB: Pagina para el "Historial MdE"

    DataCaptionExpression = StrSubstNo('%1-%2', rec."No.", rec."Nombre completo");
    Editable = false;
    PageType = List;
    SourceTable = "Historial MdE";
    SourceTableView = SORTING("No.", "No. Mov.")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
                {
                }
                field("No. Mov."; rec."No. Mov.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Tipo envio"; rec."Tipo envio")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Fecha y hora recepcion"; rec."Fecha y hora recepcion")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Fecha efectiva"; rec."Fecha efectiva")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Aplicado; rec.Aplicado)
                {
                }
                field("Fecha y hora aplicado"; rec."Fecha y hora aplicado")
                {
                    Visible = false;
                }
                field("Aplicado por usuario"; rec."Aplicado por usuario")
                {
                    Visible = false;
                }
                field("First Name"; rec."First Name")
                {
                }
                field("Last Name"; rec."Last Name")
                {
                }
                field("Second Last Name"; rec."Second Last Name")
                {
                }
                field(Initials; rec.Initials)
                {
                }
                field("Job Title"; rec."Job Title")
                {
                }
                field(Address; rec.Address)
                {
                }
                field(City; rec.City)
                {
                }
                field("Post Code"; rec."Post Code")
                {
                }
                field(County; rec.County)
                {
                }
                field("Phone No."; rec."Phone No.")
                {
                }
                field("Mobile Phone No."; rec."Mobile Phone No.")
                {
                }
                field("E-Mail"; rec."E-Mail")
                {
                }
                field("Birth Date"; rec."Birth Date")
                {
                }
                field("Social Security No."; rec."Social Security No.")
                {
                }
                field(Gender; rec.Gender)
                {
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                }
                field("Emplymt. Contract Code"; rec."Emplymt. Contract Code")
                {
                }
                field("Statistics Group Code"; rec."Statistics Group Code")
                {
                }
                field("Employment Date"; rec."Employment Date")
                {
                }
                field("Inactive Date"; rec."Inactive Date")
                {
                }
                field("Cause of Inactivity Code"; rec."Cause of Inactivity Code")
                {
                }
                field("Termination Date"; rec."Termination Date")
                {
                }
                field("Grounds for Term. Code"; rec."Grounds for Term. Code")
                {
                }
                field(_Categoria; rec._Categoria)
                {
                }
                field("Numero de persona"; rec."Numero de persona")
                {
                }
                field("Cod. Dimension"; rec."Cod. Dimension")
                {
                }
                field("Valor Dimension"; rec."Valor Dimension")
                {
                }
                field(Company; rec.Company)
                {
                }
                field("Working Center"; rec."Working Center")
                {
                }
                field("Document Type"; rec."Document Type")
                {
                }
                field("Document ID"; rec."Document ID")
                {
                }
                field("Job Type Code"; rec."Job Type Code")
                {
                }
                field("Alta contrato"; rec."Alta contrato")
                {
                }
                field("Fin contrato"; rec."Fin contrato")
                {
                }
                field(_Nacionalidad; rec._Nacionalidad)
                {
                }
                field("Lugar nacimiento"; rec."Lugar nacimiento")
                {
                }
                field("Estado civil"; rec."Estado civil")
                {
                }
                field("Mes Nacimiento"; rec."Mes Nacimiento")
                {
                }
                field(_Departamento; rec._Departamento)
                {
                }
                field("Error proceso"; rec."Error proceso")
                {
                    Visible = ShowError;
                }
                field("Descripcion error"; rec."Descripcion error")
                {
                    Visible = ShowError;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Aplicar cambio")
            {
                Caption = 'Aplicar cambio';
                Enabled = NOT rec.Aplicado;
                Image = Apply;
                Promoted = true;

                trigger OnAction()
                begin
                    if Confirm(ConfirmTxt, false) then
                        rec.ApplyManualy;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Nombre completo");
    end;

    trigger OnOpenPage()
    begin
        ShowError := (rec.GetFilter("Error proceso") <> '');
    end;

    var
        ConfirmTxt: Label 'Desea aplicar el cambio al empleado?';
        ShowError: Boolean;
}

