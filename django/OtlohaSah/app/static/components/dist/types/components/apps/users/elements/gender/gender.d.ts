export declare class Gender {
    gender: "male" | "female";
    get text(): "Male" | "Female";
    get color(): "text-primary" | "text-danger";
    get icon(): string;
    render(): any;
}
