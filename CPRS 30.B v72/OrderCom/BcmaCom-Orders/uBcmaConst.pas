unit uBcmaConst;

interface

uses uConst,rOrders, ORFn, ORNet, uCore;

const
  TX_PROV_LOC   = 'A provider and location must be selected before entering orders.';
  TC_PROV_LOC   = 'Incomplete Information';
  TX_PROV_KEY   = 'The provider selected for this encounter must' + CRLF +
                  'hold the PROVIDER key to enter orders.';
  TC_PROV_KEY   = 'PROVIDER Key Required';
  TX_NOKEY      = 'You do not have the keys required to take this action.';
  TC_NOKEY      = 'Insufficient Authority';
  TX_BADKEYS    = 'You have mutually exclusive order entry keys (ORES, ORELSE, or OREMAS).' +
                   CRLF + 'This must be resolved before you can take actions on orders.';
  TC_BADKEYS    = 'Multiple Keys';
  TC_NO_LOCK    = 'Unable to Lock';
  TC_DISABLED   = 'Item Disabled';
  TX_DELAY      = 'Now writing orders for ';
  TX_DELAY1     = CRLF + CRLF + '(To write orders for current release rather than delayed,' + CRLF +
                                 'close the next window and change to a current order view' + CRLF +
                                 'by selecting the top item in the Order Sheet box.)';
  TC_DELAY      = 'Ordering Information';
  TX_STOP_SET   = 'Do you want to stop entering the current set of orders?';
  TC_STOP_SET   = 'Interupt order set';
  TC_DLG_REJECT = 'Unable to Order';
  TX_NOFORM     = 'This selection does not have an associated windows form.';
  TC_NOFORM     = 'Missing Form ID';
  TX_DLG_ERR    = 'Error in activating order dialog.';
  TC_DLG_ERR    = 'Dialog Error';
  TX_NO_SAVE_QO = 'An ordering dialog must be active to use this action.';
  TC_NO_SAVE_QO = 'Save as Quick Order';
  TX_NO_EDIT_QO = 'An ordering dialog must be active to use this action.';
  TC_NO_EDIT_QO = 'Edit Common List';
  TX_NO_QUICK   = 'This ordering dialog does not support quick orders.';
  TC_NO_QUICK   = 'Save/Edit Quick Orders';
  TX_NO_COPY    = CRLF + CRLF + '- cannot be copied.' + CRLF + CRLF + 'Reason: ';
  TC_NO_COPY    = 'Unable to Copy Order';
  TX_NO_CHANGE  = CRLF + CRLF + '- cannot be changed.' + CRLF + CRLF + 'Reason: ';
  TC_NO_CHANGE  = 'Unable to Change Order';
  TC_NO_XFER    = 'Unable to Transfer Order';
  TC_NOLOCK     = 'Unable to Lock Order';

implementation

end.
