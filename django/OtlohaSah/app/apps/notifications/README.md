#### Notification Parameters

| parameter               | type   | description |
|-------------------------|--------|-------------|
| click_action (optional) | string |             |
| data (required)         | object |             |
| notification (required) | object |             |

#### Notification `notification` Key Parameters
| parameter                 | type   | description    |
|---------------------------|--------|----------------|
| title (optional)          | string |                |
| title_loc_args (optional) | object |                |
| title_loc_key (optional)  | string |                |
| body (optional)           | string |                |
| body_loc_args (optional)  | object |                |
| body_loc_key (optional)   | string |                |
| android (optional)        | object |                |
| apple (optional)          | object |                |
| web (optional)            | object |                |
| body_loc_key (optional)   | string |                |
| body_loc_key (optional)   | string |                |
| image (optional)          | string | image full url |
| image (optional)          | string | image full url |

#### Notification Data Parameters
| parameter               | type           | description                                                 |
|-------------------------|----------------|-------------------------------------------------------------|
| target_type (required)  | string         | defines the target is `listing` or `details`                |
| target_name (required)  | string         | defines the the target page i.e. `general_box`              |
| object_id (optional)    | string, int    | defines the target object id if target type is `details`    |
| content_type (optional) | string         | defines the target object model if target type is `details` |
| sender                  | object, string | details or id of sender                                     |

