#pragma implicitwith disable
page 76197 "Employee Info FactBox"
{
    ApplicationArea = all;
    Caption = 'Employee data';
    PageType = CardPart;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            /*         field("STRSUBSTNO('(%1)',CUNomina.BuscaNovedades(Rec))"; rec.StrSubstNo('(%1)', CUNomina.BuscaNovedades(Rec)))
                    {
                        Caption = 'Personnel actions';
                        Editable = false;

                        trigger OnDrillDown()
                        begin

                        end;
                    } */
            /*          field("STRSUBSTNO('(%1)',CUNomina.BuscaCualificaciones(""No.""))"; rec.StrSubstNo('(%1)', CUNomina.BuscaCualificaciones("No.")))
                     {
                         Caption = 'Qualifications';
                         Editable = false;

                         trigger OnDrillDown()
                         begin

                         end;
                     } */
            /*       field("STRSUBSTNO('(%1)',CUNomina.BuscaDimensiones(""No.""))"; rec.StrSubstNo('(%1)', CUNomina.BuscaDimensiones("No.")))
                  {
                      Caption = 'Dimensions';
                      Editable = false;

                      trigger OnDrillDown()
                      begin

                      end;
                  } */
            /*             field("STRSUBSTNO('(%1)',CUNomina.BuscaActividades(Rec,GETRANGEMIN(""Date Filter""),GETRANGEMAX(""Date Filter"")))"; rec.StrSubstNo('(%1)', CUNomina.BuscaActividades(Rec, GetRangeMin("Date Filter"), GetRangeMax("Date Filter"))))
                        {
                            Caption = 'Job entries';
                            Editable = false;

                            trigger OnDrillDown()
                            begin

                            end;
                        } */
            /*          field("STRSUBSTNO('(%1)',CUNomina.BuscaHistSalario(Rec))"; rec.StrSubstNo('(%1)', CUNomina.BuscaHistSalario(Rec)))
                     {
                         Caption = 'Salary History';
                         Editable = false;

                         trigger OnDrillDown()
                         begin

                         end;
                     } */
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if Rec.GetFilter("Date Filter") = '' then
            Rec.SetRange("Date Filter", 0D, DMY2Date(31, 12, Date2DMY(Today, 3)));
    end;

    var
    /*         CUNomina: Codeunit "Funciones Nomina"; */
}

#pragma implicitwith restore

