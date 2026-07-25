export declare class UserAvatar {
    link?: string;
    name?: string;
    image: string;
    get symbolStyles(): {
        "background-image": string;
    } | {
        "background-image"?: undefined;
    };
    render(): any;
}
