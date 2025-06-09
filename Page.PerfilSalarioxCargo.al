page 76068 "Perfil Salario x Cargo"
{
    ApplicationArea = all;
    DataCaptionFields = "Puesto de Trabajo";
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Perfil Salario x Cargo";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Puesto de Trabajo"; rec."Puesto de Trabajo")
                {
                }
                field("Concepto salarial"; rec."Concepto salarial")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Tipo concepto"; rec."Tipo concepto")
                {
                }
                field("1ra Quincena"; rec."1ra Quincena")
                {
                }
                field("2da Quincena"; rec."2da Quincena")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Copy All")
            {
                Caption = 'Copy All';
                Image = CopyBOM;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ConceptosSal: Record "Conceptos salariales";
                begin
                    ConceptosSal.Reset;
                    ConceptosSal.Find('-');
                    repeat
                        PerfSal.Reset;
                        PerfSal.SetRange("Concepto salarial", ConceptosSal.Codigo);
                        PerfSal.FindLast;
                        rec.Validate("Concepto salarial", ConceptosSal.Codigo);
                        rec."1ra Quincena" := PerfSal."1ra Quincena";
                        rec."2da Quincena" := PerfSal."2da Quincena";
                        if rec.Insert(true) then;
                    until ConceptosSal.Next = 0;
                end;
            }
        }
    }

    var
        PerfSal: Record "Perfil Salarial";
}

