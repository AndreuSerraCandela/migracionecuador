#pragma implicitwith disable
page 56201 "Async NAV WS Process Queue"
{
    ApplicationArea = all;

    Caption = 'Async NAV WS Process Queue';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Async NAV WS Process Queue";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Process Code"; rec."Process Code")
                {
                }
                field("Process Status"; rec."Process Status")
                {
                }
                field("Process End Date & Time"; rec."Process End Date & Time")
                {
                }
                field("Process User Id"; rec."Process User Id")
                {
                }
                field("URL Web Service"; rec."URL Web Service")
                {
                }
                field("Soap Action"; rec."Soap Action")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Ver XML recibido")
            {
                Caption = 'Ver XML recibido';
                Image = XMLFile;

                trigger OnAction()
                begin
                    ProcessData := Rec.GetReceivedData;
                    Message(ProcessData);
                end;
            }
            action("Ver XML enviado")
            {
                Caption = 'Ver XML enviado';
                Image = XMLFile;

                trigger OnAction()
                begin
                    ProcessData := Rec.GetProcessData;
                    Message(ProcessData);
                end;
            }
            action("Ver respuesta recibida")
            {
                Caption = 'Ver respuesta recibida';
                Image = XMLFile;

                trigger OnAction()
                begin
                    ResponseData := Rec.GetProcessResponse;
                    Message(ResponseData);
                end;
            }
        }
    }

    var
        ProcessData: Text;
        ResponseData: Text;
}

#pragma implicitwith restore

